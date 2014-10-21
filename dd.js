(function() {
  window.dd = {
    mobileBreakpoint: 768,
    tabletBreakpoint: 1024,
    currentDevice: null,
    currentOrientation: null,
    executeFn: null,
    handleChange: function() {
      if (dd.executeFn) {
        window.clearTimeout(dd.executeFn);
      }
      return dd.executeFn = window.setTimeout(dd.executeChange, 250);
    },
    executeChange: function() {
      var data;
      data = dd.identify();
      dd.trigger('viewportChange', data);
      if (data.device !== dd.currentDevice) {
        dd.currentDevice = data.device;
        dd.trigger('deviceChange', data);
      }
      if (data.orientation !== dd.currentOrientation) {
        dd.currentOrientation = data.orientation;
        return dd.trigger('orientationChange', data);
      }
    },
    trigger: function(eventname, data) {
      var event;
      event = new CustomEvent(eventname, {
        'detail': data
      });
      return window.dispatchEvent(event);
    },
    device: function(width) {
      if (width < dd.mobileBreakpoint) {
        return 'mobile';
      } else if (width >= dd.mobileBreakpoint && width <= dd.tabletBreakpoint) {
        return 'tablet';
      } else {
        return 'desktop';
      }
    },
    identify: function() {
      var orientation;
      if (window.outerWidth <= window.innerHeight) {
        orientation = 'portrait';
      } else {
        orientation = 'landscape';
      }
      return {
        width: window.outerWidth,
        height: window.innerHeight,
        orientation: orientation,
        device: dd.device(window.outerWidth)
      };
    },
    init: function() {
      window.addEventListener('resize', (function() {
        return dd.handleChange();
      }), false);
      window.addEventListener('orientationchange', (function() {
        alert(window.orientation);
        return dd.handleChange();
      }), false);
      return dd.executeChange();
    }
  };

}).call(this);
