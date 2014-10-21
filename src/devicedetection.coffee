# dd should trigger a custom event when:
# - the viewport size changes
# - the orientation changes
# - the device changes

window.dd = 

    mobileBreakpoint: 768
    tabletBreakpoint: 1024
    currentDevice: null
    currentOrientation: null
    executeFn: null

    handleChange: ->
        # We want to prevent firing event too many times when resizing
        # So we set a timeout function, so it'll only execute when the
        # resize has stopped for about 50ms
        if dd.executeFn
            # Kill the current timeout and set a new one
            window.clearTimeout(dd.executeFn);
        dd.executeFn = window.setTimeout(dd.executeChange, 250)

    executeChange: ->
        data = dd.identify()
        dd.trigger('viewportChange', data)

        if data.device != dd.currentDevice
            dd.currentDevice = data.device
            dd.trigger('deviceChange', data)

        if data.orientation != dd.currentOrientation
            dd.currentOrientation = data.orientation
            dd.trigger('orientationChange', data)

    trigger: (eventname, data)->
        event = new CustomEvent(eventname, {'detail':data})
        window.dispatchEvent event

    device: (width)->
        if width < dd.mobileBreakpoint
            return 'mobile'
        else if width >= dd.mobileBreakpoint and width <= dd.tabletBreakpoint
            return 'tablet'
        else
            return 'desktop'

    identify: ->

        if window.innerWidth <= window.innerHeight
            orientation = 'portrait'
        else
            orientation = 'landscape'

        return {
            width: window.innerWidth
            height: window.innerHeight
            orientation: orientation
            device: dd.device(window.innerWidth)
        }

    init: ->
        # Listen to window resize
        window.addEventListener 'resize', (->
            dd.handleChange()
        ), false

        # Listen to orientation change
        window.addEventListener 'orientationchange', (->
            dd.handleChange()
        ), false

        # Trigger all event on load
        dd.executeChange()

# @@TODO
# Implement polyfill for event handling
# (function () {
#   function CustomEvent ( event, params ) {
#     params = params || { bubbles: false, cancelable: false, detail: undefined };
#     var evt = document.createEvent( 'CustomEvent' );
#     evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
#     return evt;
#    };

#   CustomEvent.prototype = window.Event.prototype;

#   window.CustomEvent = CustomEvent;
# })();