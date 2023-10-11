(function ($) {

    function PageNoTabsView(dom, opts){
        this.target = $(dom);
        this.opts = opts;
        this.pages = this.opts.pages;
        this.hideAddNewButton = this.opts.hideAddNewButton;
        this.pageNoTabArray = [];
        this.addNewPageTab = null;
        this.init();
    }

    PageNoTabsView.prototype = {
        constructor : PageNoTabsView,

        init: function(){
            this.activeCss={
                "text-align": "center",
                "border": "1px solid #B4C9C6",
                "float": "left",
                "padding": "5px 0 0 0",
                "margin": "5px 5px 0 0",
                "border-radius": "5px 5px 0 0",
                "width": "80px",
                "background-color" : "white",
                "font-weight": "bold",
                "cursor":"default"
            };

            this.deactiveCss=$.extend({}, this.activeCss, {
                "background-color" : "#D8DFDD",
                "font-weight": "normal",
                "cursor":"pointer"
            });

            this.addNewPageTabCss=$.extend({}, this.deactiveCss, {
                "width": "30px"
            });

            this.render();
        },

        render: function(){
            var t = this.target.empty();
            var $this = this;
            this.pageNoTabArray = [];

            for(var i=0; i < this.pages.length; i++){
                var singlePageTab = $("<div>ç¬? + this.pages[i] + "é¡?/div>");
                singlePageTab.css(this.activeCss);
                singlePageTab.data("data",{
                    pageNo: $this.pages[i]
                });
                singlePageTab.click(function(){
                    var data = $(this).data("data");
                    var pageNo = data.pageNo;
                    $this.setActiveTab(pageNo);
                    if($this.opts.onPageNoTabSelected){
                        $this.opts.onPageNoTabSelected(pageNo);
                    }
                });
                singlePageTab.appendTo(t);
                this.pageNoTabArray.push(singlePageTab);
            }

            if(!this.hideAddNewButton){
                this.addNewPageTab = $("<div>+</div>");
                this.addNewPageTab.css(this.addNewPageTabCss);
                this.addNewPageTab.appendTo(t);
                this.addNewPageTab.click(function(){
                    if($this.opts.onAddNewPageTab){
                        $this.opts.onAddNewPageTab();
                    }
                });
            }
            

            this.setActiveTab($this.pages[0]);
        },

        setActiveTab: function(pageNo){
            for(var i=0; i < this.pageNoTabArray.length; i++){
                var singlePageTab = this.pageNoTabArray[i];
                var data = singlePageTab.data("data");
                var currentPageNo = data.pageNo;
                if(pageNo == currentPageNo){
                    singlePageTab.css(this.activeCss);
                    singlePageTab.siblings().css(this.deactiveCss);
                    if(!this.hideAddNewButton){
                        this.addNewPageTab.css(this.addNewPageTabCss);
                    }
                    
                    return;
                }
            }
        },

        addNewTab: function(pageNo){
            this.pages.push(pageNo);
            this.render();
            this.setActiveTab(pageNo);
        }
    }

    $.fn.extend({
        PageNoTabs: function (options, param) {
            if (typeof options == "string") {
                return $.fn.PageNoTabs.methods[options](this, param);
            };

            var defaluts = {

            };

            var opts = $.extend({}, defaluts, options); 
            return this.each(function () {  
                var pageNoTabsView = new PageNoTabsView(this, opts);
                $(this).data("PageNoTabsView", pageNoTabsView);
            });
        }
    });

    $.fn.PageNoTabs.methods = {
        setBackgroudColor : function(jq,param){
            return jq.each(function(){

            });
        },

        getOptions : function(jq,param){
            
        },

        addNewTab: function(jq, param){
            return jq.each(function(){
                var pageNo = param.pageNo;
                var pageNoTabsView = $(this).data("PageNoTabsView");
                pageNoTabsView.addNewTab(pageNo);
            });
        }
    };

})(window.jQuery);