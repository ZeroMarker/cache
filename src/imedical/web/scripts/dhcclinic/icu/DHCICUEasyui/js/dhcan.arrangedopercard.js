//(function($,window,document,undefined){
    var _methods={};
    var defualtOptions={
        header:null,
        content:null,
        footer:null
    } 
    function ArrangedOperCard(operSchedule,seq,opts){
        this.dataSource=operSchedule;
        this._options=defualtOptions;
        this._dom=$('<div class="oper-card"></div>');
        this._menubutton = null;
    }
    ArrangedOperCard.prototype={
        constructor:ArrangedOperCard,
        _init:function(){
            var _this = this;
			this._dom.attr('data-opsId',this.dataSource.RowId);
            if(this.dataSource.OperSeq||seq){
                this._dom.attr('data-seq',this.dataSource.OperSeq);
                var header = $('<div class="oper-card-header"></div>');
                header.html((this._options.header||_methods.ArrangedOperCard.header)(this.dataSource));
                this._dom.append(header);
            }

            this._menubutton = $('<span class="oper-card-menubutton" style="display:none;">...</span>');
            this._dom.append(this._menubutton);
            this._menubutton.mouseenter(function() {
                event.stopPropagation();
                //_this._options.menu.menu('show', $(this).offset());
                //if (!_this.selected) {
                   // clearCardSelection();
               //     _this.select();
               // }
            });
           
            var content = $('<div class="oper-card-content"></div>');
            content.html((this._options.content || _methods.ArrangedOperCard.content)(this.dataSource));
            this._dom.append(content);

            var footer = $('<div class="oper-card-footer"></div>');
            var footerInnerHtml = (this._options.footer || _methods.ArrangedOperCard.footer)(this.dataSource);
            if (footerInnerHtml) {
                footer.html(footerInnerHtml);
                this._dom.append(footer);
            }
            this._dom.mouseenter(function() { _this.onEnter() });
            this._dom.mouseleave(function() { _this.onLeave() });

            return this._dom;
        },
        onEnter: function() {
            this._menubutton.show();
        },
        onLeave: function() {
            this._menubutton.hide();
        },
    }
    _methods.ArrangedOperCard={
        header:function(operSchedule){
            var headerArray=[];
            headerArray.push('第'+operSchedule.OperSeq+'台');
            return headerArray.join('');
        },
        /**
         * 通过手术安排数据对象获取相应的中部显示内容
         */
        content: function(operSchedule) {
            var contentArray = [];
            contentArray.push('<span style="font-weight:bold;">' + operSchedule.Patient + '</span>');
            // contentArray.push('<span>' + operSchedule.PatDeptDesc + '</span>');
            contentArray.push('<span>' + operSchedule.WardBed + '</span>');
            contentArray.push('<span>' + operSchedule.SurgeonDesc + '</span>');
            contentArray.push('<br/><span>' + operSchedule.OperInfo + '</span>');

            return contentArray.join('');
        },
        /**
         * 通过手术安排数据对象获取相应的底部显示内容
         */
        footer: function(operSchedule) {
            var footerArray = [];
            if (operSchedule.SourceType === 'E') {
                footerArray.push('<span style="color:#ff0000;">急</span>');
            }

            return footerArray.join('');
        }
    }

    function generateMenu(parent, opt) {
        if ($.isArray(opt.items))
            $.each(opt.items, function(index, item) {
                parent.append(generateMenuItem(item));
            });
    }

    /**
     * 生成菜单项
     * @param {object} opt 
     */
    function generateMenuItem(opt) {
        var menuItem = $('<div></div>').html('<span>' + opt.text + '</span>');
        if(opt.id){
            menuItem.attr('data-id',opt.id);
            menuItem.id=opt.id;
        }
        menuItem.data('options', opt);
        if ($.isArray(opt.items)) {
            var subMenu = $('<div></div>');
            menuItem.append(subMenu);
            generateMenu(subMenu, opt);
        }
        return menuItem;
    }

//})($,window,document)