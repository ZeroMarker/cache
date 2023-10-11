/**
 * copy:scripts/bsp.sys.keyvaluebox.js 后改造
 * 显示面板 initKeyValueBox initCombo2grid使用
 * @param {*} _860 dom元素
 * @param {*} onShowPanel 显示面板时调用方法
 */
function _85f(_860,onShowPanel) {
    var _861 = $.data(_860, "combo2");
    var opts = _861.options||{};
    var _862 = $(_860)
    var _863 = _861.panel;
    _863.panel("move", { left: _864(), top: _865() });
    if (_863.panel("options").closed) {
        _863.panel("open");
       if (onShowPanel) onShowPanel.call(_860);
    }
    (function () {
        if (_863.is(":visible")) {
            _863.panel("move", { left: _864(), top: _865() });
            setTimeout(arguments.callee, 200);
        }
    })();
    function _864() {
        var left = _862.offset().left;
        if (opts.panelAlign == "right") {
            left += _862._outerWidth() - _863._outerWidth();
        }
        if (left + _863._outerWidth() > $(window)._outerWidth() + $(document).scrollLeft()) {
            left = $(window)._outerWidth() + $(document).scrollLeft() - _863._outerWidth();
        }
        if (left < 0) {
            left = 0;
        }
        return left;
    };
    function _865() {
        var top = _862.offset().top + _862._outerHeight()-1;
        if (top + _863._outerHeight() > $(window)._outerHeight() + $(document).scrollTop()) {
            top = _862.offset().top - _863._outerHeight();
        }
        if (top < $(document).scrollTop()) {
            top = _862.offset().top + _862._outerHeight()-1;
        }
        return top;
    };
};

///加载CSS样式
function LoadStyleText(cssText){
	var style = document.createElement('style');
	style.type = 'text/css';
	style.innerHTML=cssText
	document.getElementsByTagName('head').item(0).appendChild(style);
}
/// 加载combo2样式
function LoadCombo2Css(size){
	size=size||30;
	LoadStyleText('		\
		.combo2-arrow{\
			display:inline-block;\
			width:'+(size-2)+'px;\
			height:'+(size-2)+'px;\
			margin-left:10px;\
			background:url(../images/uiimages/input-btn-expand.png)	no-repeat center center;\
			background-color:#abddff;\
			cursor:pointer;\
			border:1px solid #40a2de;\
			vertical-align:top;\
		}\
		.combo2-arrow.disabled{\
			border-color:#bbb;\
			background-color:#bbb;\
		}\
		.combo2-p>.combo2-panel {\
		    border-color: #9ed2f2;\
		    border-radius: 0px;\
		}\
		.combo2-panel-content{\
			padding:0px;\
			border-radius: 0px;\
		}\
		.combo2-panel-buttons{\
			text-align:center;\
		}\
		.panel.combo2-p{\
			box-shadow: 0px 3px 3px 3px rgba(0, 0, 0, 0.1);\
		}\
		.panel-body.panel-body-noheader{\
    		border-radius: 0px;\
		}\
	');
}


//==============创建键值录入框=======================================================================================================================
/**
 * 
 * @param {*} target dom元素
 * @param {*} opts 配置项
 */
function initKeyValueBox(target,opts){
	if (!opts.valueEditor) opts.valueEditor='text';
	$(target).width($(target).width()-40).addClass('combo2');
	var arrow=$('<span class="combo2-arrow"></span>').insertAfter(target);
    var p = $("<div class=\"combo2-panel\" ></div>").appendTo("body");
    p.panel({
        doSize: false, closed: true, cls: "combo2-p", style: { position: "absolute", zIndex: 10 }, onOpen: function () {
            var p = $(this).panel("panel");
            if ($.fn.menu) {
                p.css("z-index", $.fn.menu.defaults.zIndex++);
            } else {
                if ($.fn.window) {
                    p.css("z-index", $.fn.window.defaults.zIndex++);
                }
            }
            $(this).panel("resize");
        }
    });
    p.panel("resize",{width:opts.panelWidth,height:opts.panelHeight});
    $.data(target,'combo2',{panel:p});
    
    $(arrow).off('click.combo2').on('click.combo2',function(){
	    if($(this).hasClass('disabled')) return false;
	    if (opts.checkValue){
			if(opts.checkValue.call(target,$(target).val())===false){
				return ;
			}
		}
	    
	    _85f(target,function(){
		    var target=this;
			var all=opts.parseValue($(target).val());
			var table=$('<table class="combo2-panel-content-dg" id="combo2-panel-content-dg"></table>');
			if (opts.innerhtml){
				$.data(target, "combo2").panel.find('.combo2-panel-content').empty().append(opts.innerhtml);
				$.data(target, "combo2").panel.find('.combo2-panel-content').append(table);	
			}else{
				$.data(target, "combo2").panel.find('.combo2-panel-content').empty().append(table);
			}
			table.data('editindex','-1');
			table.datagrid({
				columns:[[
					{field:'key',title:opts.keyTitle||'参数名',width:200,editor:'text'},
					{field:'value',title:opts.valueTitle||'参数值',width:200,editor:opts.valueEditor},
					{field:'desc',title:opts.descTitle||'说明',width:200,editor:opts.descEditor}
				]],
				fit:true,
				data:all,
				rownumbers:true,
				bodyCls:'panel-header-gray',
				onClickRow:function(index,row){
					var editindex=$(this).data('editindex')
					if( editindex==index){
						$(this).datagrid('endEdit', index);
						editindex=-1;
					}else{
						if(editindex>-1) $(this).datagrid('endEdit', editindex);
						if((index==$(this).datagrid('getRows').length-1)&&(opts.singleRow!="Y")){  
							//只要点击最后一行 就新增一行
							$(this).datagrid('appendRow',{key:'',value:'',custom:true,desc:''});
						}
						$(this).datagrid('beginEdit', index);
						editindex=index;
						if (!row.custom){
							var et=$(this).datagrid('getEditor',{index:index,field:'key'}).target;
							$(et).attr('disabled','disabled');
						}
					}
					$(this).data('editindex',editindex)
				},
				onAfterEdit:function(index,rowData){
					if( index==$(this).datagrid('getRows').length-1){  //最后一行
						if(opts.singleRow!="Y" && rowData.key!="" && rowData.value!="" ){
							$(this).datagrid('appendRow',{key:'',value:'',custom:true,desc:''});
						}
					}
				}
				
			})
			if (typeof opts.callback=="function") opts.callback();
		});
	})
	$('<div class="combo2-panel-content"></div>').appendTo(p).outerHeight(opts.panelHeight-40-2);
	var buttons=$('<div class="combo2-panel-buttons"></div>').appendTo(p);
	var $okBtn=$('<a>确定</a>').appendTo(buttons).linkbutton({
		stopAllEventOnDisabled:true
	})
	$okBtn.off('click.combo2').on('click.combo2',function(){
		var table=p.find('.combo2-panel-content-dg');
		var editindex=table.data('editindex');
		if (editindex>-1) table.datagrid('endEdit',editindex);
		var rows=table.datagrid('getRows');
		
		var str=opts.formatValue(rows);
		if (!str) return false;
		$(target).val(str);
		
		p.panel('close');
	})
	var $cancelBtn=$('<a style="margin-left:15px;">取消</a>').appendTo(buttons).linkbutton({
		stopAllEventOnDisabled:true
	})
	$cancelBtn.off('click.combo2').on('click.combo2',function(){
		p.panel('close');
	})
	
    $(document).off(".combo2").on("mousedown.combo2", function (e) {
        var p = $(e.target).closest(".combo2,div.combo2-p");
        if (p.length) {
            return;
        }
        $("body>div.combo2-p>div.combo2-panel:visible").panel("close");
    });	
}
//==============创建键值录入框 END  =======================================================================================================================

