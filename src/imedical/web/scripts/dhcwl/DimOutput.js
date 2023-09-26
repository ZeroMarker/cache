(function(){
	Ext.ns("dhcwl.mkpi.DimOutout");
})();
dhcwl.mkpi.DimOutput=function(){
	var type="kpiRule", kpiTreeArg="";
	var kpiRuleStr="";
	var outThis=this;
	
	var kpiTreePanel = new Ext.tree.TreePanel({
	    tbar: [{
	            id:'export',
	            text: '<span style="line-Height:1">导出</span>',
				icon   : '../images/uiimages/redo.png',
	            handler: onExport2,
	            scope: this
	    }],
		//title:'指标取数规则解析来的指标树',
		id:'kpiTreePanel',
		width:480,
		height:500,
		autoScroll:true,
		rootVisible:true,
		split:true,
		loader:new Ext.tree.TreeLoader({
			dataUrl:'dhcwl/kpi/kpidimservice.csp?action=getList&type=root'
		}),
		root:new Ext.tree.AsyncTreeNode({
			id:'root',
			text:'维度树\/指标维度\/维度属性',
			expanded:false
		}),
		listeners:{
			'click':function(node,e){
				node.toggle();
				currentLeafNode = node;
			},
			'dblclick':function(node,e){
				
			},
			'beforeload':function(node){
				var args = node.id.split("-");
				type = args[0];
				if ('root'==type) {
					kpiTreeArg = '&kpiRuleStr='+kpiRuleStr;
				} else if ('dim'==type) {
					kpiTreeArg = '&kpiRuleStr=&dimCode='+node.text;	//取指标的全部指标维度
				}  
				//alert(type+kpiTreeArg);
				node.loader = new Ext.tree.TreeLoader({
					dataUrl:'dhcwl/kpi/kpidimservice.csp?action=getList&type='+type+kpiTreeArg
				});
			}
		}
	});
	function onExport2(btn, ev) {
        var nodeIDs = '', selNodes = kpiTreePanel.getChecked();
        
        if(selNodes.length==0){
			alert("导出列表为空，请先选择要导出的模块！");
			return;
		}
		
        Ext.each(selNodes, function(node){
            if(nodeIDs.length > 0){
                nodeIDs += ","+node.id;
            }else{
	            nodeIDs=node.id
            }
        });
        //alert(nodeIDs);
        //return;
        dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/dimioservice.csp',
				{action:'getFileContent',nodeIDs:nodeIDs},
			function(responseText){
				if(responseText){
					dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+'outputDims.dim',dhcwl.mkpi.Util.trimLeft(responseText));
				}else{
					Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
				}
		
			}
			,outThis,true,null);
	}
	
	
	var setFilterWin = new Ext.Window({
		title:'导出维度、维度属性选择',
		width:500,
		height:530,
		resizable:true,
		modal:true,
		items:kpiTreePanel
	});
	
	
	this.show = function(){
		setFilterWin.show();
	}
}

