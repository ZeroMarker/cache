/**
 * FileName: dhcbill.conf.general.product.js
 * Author: wzh
 * Date: 2022-10-12
 * Description: 计费医保通用配置产品维护
 */

// 初始化
$(function() {
	$("#func-search").searchbox({
		searcher: function(value) {
			GV.FuncTree.search(value);
		}
	});
	
	initFuncTree();
	
});

function initFuncTree() {
	GV.FuncTree = $HUI.tree("#funcTree", {
		fit: true,
		animate: true,
		url: $URL + '?ClassName=BILL.CFG.COM.GeneralPro&MethodName=BuildTree&ResultSetType=array',
		onDblClick: function (node) {
			$(this).tree("toggle", node.target);
		},
		onSelect: function(node) {
			//alert(node.attributes.type)
			loadFuncPage(node,"query");
		},
		onContextMenu: onContextMenuHandler
	});
};


function loadFuncPage(node,mode) {
	var id = node.attributes.id;
	var type = node.attributes.type;
	var text = node.text;
	var	url = "";
	// 添加子节点则根据type调用子节点界面
	if (mode == "addChild"){
		switch(type){
			case "Pro":
				url = "dhcbill.conf.general.proModule.csp";
				break;
			case "Mod":
				url = "dhcbill.conf.general.functionPoint.csp";
				break;
			default:
				url = "dhcbill.nodata.warning.csp";
		}
	}else{// 其它类型调用自己的界面
		switch(type){
			case "Pro":
				url = "dhcbill.conf.general.proLine.csp";
				break;
			case "Mod":
				url = "dhcbill.conf.general.proModule.csp";
				break;
			case "P1":
				url = "dhcbill.conf.general.functionPoint.csp";
				break;
			default:
				url = "dhcbill.nodata.warning.csp";
		}
	}
	var src = url + "?Id=" + id + "&Type=" + mode;
	if ('undefined' !== typeof websys_getMWToken){
		src += "&MWToken="+websys_getMWToken();
	}
	if ($("iframe").attr("src") != src) {
		$("iframe").attr("src", src);
	}
};

function onContextMenuHandler(e, node) {
	e.preventDefault();
	if (!node) {
		return;
	}
	GV.node = node;
	var target = "rightMenu";
	var $target = $("#" + target);
	if (!$target.length) {
		$target = $("<div id=\"" + target + "\"></div>").appendTo("body");
	}
	$target.menu().empty();   //需要清空集合
	
	var menus = [];
	var type = node.attributes.type;
	switch(type){
		case "Pro":
			menus = Array.apply(menus, [{
                        text: '新增本级',
                        iconCls: 'icon-add',
                        handler: "loadFuncPageForAdd"
                    }, {
	                    text: '新增下级',
	                    iconCls: 'icon-add',
	                    handler: "loadFuncPageForAddChild"
	                }, {
                        text: '修改',
                        iconCls: 'icon-write-order',
                        handler: "loadFuncPageForUpdate"
                    }
                ]);
			break;
		case "Mod":
			menus = Array.apply(menus, [{
	                    text: '新增本级',
	                    iconCls: 'icon-add',
	                    handler: "loadFuncPageForAdd"
	                }, {
	                    text: '新增下级',
	                    iconCls: 'icon-add',
	                    handler: "loadFuncPageForAddChild"
	                }, {
	                    text: '修改',
	                    iconCls: 'icon-write-order',
	                    handler: "loadFuncPageForUpdate"
	                }
	            ]);
			break;
		case "Func":
			break;
		default:
			$.messager.popover({msg: "选中节点异常！", type: "error"});
	}
	menus.forEach(function(item, idx) {
		$target.menu("appendItem", {
			text: item.text,
			iconCls: item.iconCls,
			onclick: eval("(" + item.handler + ")")
		});
	});
	$target.menu("show", {
		left: e.pageX,
		top: e.pageY
	});	
};

function loadFuncPageForAdd() {
	loadFuncPage(GV.node,"add");
}
function loadFuncPageForAddChild() {
	loadFuncPage(GV.node,"addChild");
}
function loadFuncPageForUpdate() {
	loadFuncPage(GV.node,"update");
}