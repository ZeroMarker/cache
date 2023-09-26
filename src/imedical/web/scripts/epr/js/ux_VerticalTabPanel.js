Ext.ns("Ext.ux");

/**
 * @class Ext.ux.TabPanel
 * @extends Ext.TabPanel
 * @author <a href="mailto:me@carina.net">Carina Stumpf</a>
 * @version 0.2
 *
 * An extension for Ext.TabPanel that enables tabs to be positioned on the left or right side of a TabPanel.
 *
 * Modified by <a href="mailto:akononyhin@list.ru">Alexey Kononykhin</a>. Tabs' scrolling has been added.
 */


/**
 * @constructor
 * @param {Object} cfg A config object
 *  @cfg {String} tabPosition 'top' (the ext default behaviour), 'bottom' (also ext default), 'left' (vertical tabs on the left side) or right (vertical tabs on the right side)
 *  @cfg {Number} tabWidth (only applies if tabPosition is set to 'left' or 'right') the width of the tab strip in pixel; defaults to 150
 *  @cfg {String} textAlign 'left' or 'right', defaults to 'left' (only applies if tabPosition is set to 'left' or 'right')
 */
Ext.ux.TabPanel = function(cfg) {
  if (cfg.tabPosition == 'left' || cfg.tabPosition == 'right') {
    cfg.cls = cfg.cls || '';
    cfg.cls = 'ux-vertical-tabs ' + cfg.cls;
    if (cfg.textAlign && cfg.textAlign == 'right') {
      cfg.cls = 'ux-vertical-tabs-alignright ' + cfg.cls;
    }
    cfg.cls = (cfg.tabPosition == 'left' ? 'ux-vertical-tabs-left ' : 'ux-vertical-tabs-right ') + cfg.cls;
    cfg.intendedTabPosition = cfg.tabPosition;
    cfg.verticalTabs = true;
    cfg.tabPosition = 'top';
  }
  else {
    cfg.verticalTabs = false;
  }

  Ext.ux.TabPanel.superclass.constructor.call(this, cfg);

};



Ext.extend(Ext.ux.TabPanel, Ext.TabPanel, {
  tabWidth : 150,


  afterRender : function() {
    Ext.ux.TabPanel.superclass.afterRender.call(this);
    if (this.verticalTabs) {
      this.header.setWidth(this.tabWidth);
      this.header.setHeight(this.height || this.container.getHeight());
    }
  },


/**
 * Adjust header and footer size.
 * @param {Number} w width of the container
 * @return {Number} the body will be resized to this width
 */

  adjustBodyWidth : function(w) {
    if (this.verticalTabs) {
      if (Ext.isIE6) {
        //I got the value "3" through trial and error; it seems to be related with the x-panel-header border; if the border
        //is set to "none", then this substraction is not necessary - but it does not seem related to the border width, margin or padding of any
        //of the panels so I dont know how to calculate it; please let me know if you have any idea what's going on here
        this.bwrap.setWidth(w );
      }
      return w;
    }
    else {
      return Ext.ux.TabPanel.superclass.adjustBodyWidth.call(this, w);
    }
  },

/**
 * Get the new body height and adjust the height of the tab strip if it is vertical.
 * @param h {Number}
 */
  adjustBodyHeight : function(h) {
    if (this.verticalTabs) {
      this.header.setHeight(h + (this.tbar ? this.tbar.getHeight() : 0));
    }
    return Ext.ux.TabPanel.superclass.adjustBodyHeight.call(this, h);
  },

/**
 * If the tab strip is vertical, we need to substract the "header" width.
 * @return {Number} The frame width
 */
  getFrameWidth : function() {
    return Ext.ux.TabPanel.superclass.getFrameWidth.call(this) + this.verticalTabs ? this.tabWidth : 0;
  },

/**
 * If the tab strip is vertical, we don't need to substract it's height
 * @return {Number} The frame height
 */
  getFrameHeight : function() {
    return Ext.ux.TabPanel.superclass.getFrameHeight.call(this) - (this.verticalTabs ? this.header.getHeight() : 0);
  },



    // private
    autoScrollTabs : function(){
        if (!this.verticalTabs) {
            Ext.ux.TabPanel.superclass.autoScrollTabs.call(this);
            return;
        }
        this.pos = this.header;
        var count = this.items.length;
        var scrollAreaHeight = this.pos.dom.clientHeight;

        var wrap = this.stripWrap;
        var wd = wrap.dom;
        var ch = wd.offsetHeight;
        var heightOfAllTabs = this.getHeightOfAllTabs() + this.getScrollPos();

        if(!this.enableTabScroll || count < 1 || ch < 20){ // 20 to prevent display:none issues
            return;
        }
        if(heightOfAllTabs <= scrollAreaHeight){
            if(this.scrolling){
                wd.scrollTop = 0;
                //this.pos.setWidth(this.pos.getWidth() - 18);  //<+ modified on 2010-12-28 by houj: 增加TabWidth会导致TabContent显示不全，因为增加的宽度会把Tab向左推导致左边内容被遮住>
                this.scrolling = false;
                this.pos.removeClass('x-tab-scrolling');
                this.scrollTop.hide();
                this.scrollBottom.hide();
                if(Ext.isAir /*|| Ext.isSafari*/){
                    this.pos.dom.style.marginRight = '';
                }
            }
        }else{
            if(!this.scrolling){
                var tabsWidth = this.pos.getWidth();
                this.pos.addClass('x-tab-scrolling');
                //var newWidth = tabsWidth + 18;    //<+ modified on 2010-12-28 by houj: 增加TabWidth会导致TabContent显示不全，因为增加的宽度会把Tab向左推导致左边内容被遮住>
                //this.pos.setWidth(newWidth);      
                //wrap.setWidth(tabsWidth);         

                if(Ext.isAir /*|| Ext.isSafari*/){
                    this.pos.dom.style.marginRight = '18px';
                }
                if(!this.scrollTop){
                    this.createScrollers();
                }else{
                    this.scrollTop.show();
                    this.scrollBottom.show();
                }
            }
            this.scrolling = true;
            if(this.getScrollPos() > (heightOfAllTabs - scrollAreaHeight)){ // ensure it stays within bounds
                wrap.dom.scrollTop = heightOfAllTabs - scrollAreaHeight;
            }else{ // otherwise, make sure the active tab is still visible
                this.scrollToTab(this.activeTab, false);
            }
            this.updateScrollButtons();
            this.updateScrollersPosition();
        }
    },


    // private
    createScrollers : function(){
        if (!this.verticalTabs) {
            Ext.ux.TabPanel.superclass.createScrollers.call(this);
            return;
        }
        this.pos.addClass('x-tab-scrolling-' + this.tabPosition);
        var w = this.stripWrap.dom.offsetWidth;

        // top
        var st = this.pos.insertFirst({
            cls:'x-tab-scroller-top'
        });
        st.setWidth(w);
        st.addClassOnOver('x-tab-scroller-top-over');
        this.topRepeater = new Ext.util.ClickRepeater(st, {
            interval : this.scrollRepeatInterval,
            handler: this.onScrollTop,
            scope: this
        });
        this.scrollTop = st;

        // bottom
        var sb = this.pos.insertFirst({
            cls:'x-tab-scroller-bottom'
        });

        sb.setWidth(w);
        sb.addClassOnOver('x-tab-scroller-bottom-over');
        this.bottomRepeater = new Ext.util.ClickRepeater(sb, {
            interval : this.scrollRepeatInterval,
            handler: this.onScrollBottom,
            scope: this
        });
        this.scrollBottom = sb;
    },

    updateScrollersPosition: function(){
        if (!this.verticalTabs) {
            return;
        }
        if(!this.scrollTop || !this.scrollBottom) {
            createScrollers();
        }
        this.scrollTop.setX(this.pos.getX() + this.pos.getWidth() - 18);

        this.scrollBottom.setX(this.pos.getX() + this.pos.getWidth() - 18);
        this.scrollBottom.setY(this.pos.getY() + this.pos.getHeight() - 18);
    },

    // private
    getHeightOfAllTabs : function(){
        return this.edge.getOffsetsTo(this.stripWrap)[1];
    },

    // private
    getScrollHeight : function(){
        return this.getHeightOfAllTabs() + this.getScrollPos();
    },

    // private
    getScrollPos : function(){
        if (!this.verticalTabs) {
            return Ext.ux.TabPanel.superclass.getScrollPos.call(this);
        }
        return parseInt(this.stripWrap.dom.scrollTop, 10) || 0;
    },

    // private
    getScrollArea : function(){
        if (!this.verticalTabs) {
            return Ext.ux.TabPanel.superclass.getScrollArea.call(this);
        }
        return parseInt(this.stripWrap.dom.clientHeight, 10) || 0;
    },

    // private
    updateScrollButtons : function(){
        if (!this.verticalTabs) {
            Ext.ux.TabPanel.superclass.updateScrollButtons.call(this);
            return;
        }
        var pos = this.getScrollPos();
        this.scrollTop[pos == 0 ? 'addClass' : 'removeClass']('x-tab-scroller-top-disabled');
        this.scrollBottom[(pos + this.getScrollArea()) >= this.getScrollHeight() ? 'addClass' : 'removeClass']('x-tab-scroller-bottom-disabled');
    },

    // private
    onScrollBottom : function(){
        var sh = this.getScrollHeight()-this.getScrollArea();
        var pos = this.getScrollPos();
        var s = Math.min(sh, pos + this.getScrollIncrement());
        if(s != pos){
            this.scrollTo(s, this.animScroll);
        }
    },

    // private
    onScrollTop : function(){
        var pos = this.getScrollPos();
        var s = Math.max(0, pos - this.getScrollIncrement());
        if(s != pos){
            this.scrollTo(s, this.animScroll);
        }
    },

    // private
    scrollTo : function(pos, animate){
        if (!this.verticalTabs) {
            Ext.ux.TabPanel.superclass.scrollTo.call(this, pos, animate);
            return;
        }
        this.stripWrap.scrollTo('top', pos, animate ? this.getScrollAnim() : false);
        if(!animate){
            this.updateScrollButtons();
        }
    }
});
