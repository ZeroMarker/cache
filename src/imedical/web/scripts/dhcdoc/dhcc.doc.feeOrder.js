/**!
* @author: wanghc
* @date:   2012-04-08
* @desc:   执行医嘱费用情况查询
* 用到dhcc.doc.OrderCenter.js内的dhcc.doc.getOperateProxy方法
* dhcdoc/dhcc.doc.feeOrder.js
*/
var cancelFeeOrderHandler;
var cancelFeeOrderShowHandler;
Ext.ns("dhcc.doc");
Ext.onReady(function(){
	Ext.QuickTips.init();
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var internalType = orderGridPanel.internalType;
	var orderType = orderGridPanel.orderType;
	dhcc.doc.feeOrder = new dhcc.icare.MixGridPanel({
		title: "费用明细",		
		split: true,
		region: 'south',
		listClassName: "web.DHCDocMain",
		listQueryName: 'FindOrderFee',
		columnModelFieldJson: window.feeMetaDataJson||"",
		pageSize:20,
		height: feeListHeight,
		collapsible: true,
		collapsed:true,
		cmHandler: function(cms){
			var len = cms.length, i, statuDesc = "HIDDEN2";
			for( i = 0 ; i < len; i++){		
				if(cms[i].dataIndex == "TQty"){
					cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){
						if( record.data[statuDesc] == "R"){
							metaData.attr = "style='background-color: wheat;'";						
						}
						return value;
					}
				}
			}
			return cms;	
		},
		rowContextMenuHandler:function(g,rowIndex,e){
			e.stopEvent();		
			g.getSelectionModel().selectRow(rowIndex);
			var r = g.store.getAt(rowIndex);
			var rightKeyMenu=g.rightKeyMenu
			if(dhcc.doc.execOrder.Priority){
				if(dhcc.doc.execOrder.Priority.indexOf("长期")>=0){
					var rightKeyMenu=g.rightKeyMenu	
				}else{
					if(g.rightSOSKeyMenu){
						var rightKeyMenu=g.rightSOSKeyMenu
					}
				}	
			}
			if(!rightKeyMenu) return;
			//g.rightKeyMenuHidden = false;
			if(false === g.fireEvent('rightKeyMenuShow',g,rowIndex)){
				g.rightKeyMenuHidden = true;
			}
			
			if(g.rightKeyMenuHidden) return ;
			rightKeyMenu.items.each(function(item){
				var status = item.displayHandler || {};			//2012-04-18 wanghc
				var arr,flag = true;
				if('function' == typeof status){				
					flag = status.call(this,r,rowIndex);	//this-->item 当前菜单项目
				}else if('object' == typeof status){
					for (statu in status){
						if(status.hasOwnProperty(statu)){
							arr = statu.split("_");							
							flag = flag && (arr[1] == "Display") ;	
							if (status[statu].indexOf(r.data[arr[0]]) == -1) {
								flag = !flag;								
							} 													
						}
						if (!flag){break;}					//不显示就跳出
					}	
				}
				item.setDisabled(!flag);
				var cmp = Ext.getCmp(item.id)
				if(cmp && cmp.el && "undefined" !== typeof item.qtip){				
					cmp.el.dom.setAttribute("ext:qtip",item.qtip);
					if("undefined" !== typeof item.qtitle) cmp.el.dom.setAttribute("ext:qtitle",item.qtitle);
				}			
		});	
		rightKeyMenu.showAt(e.getXY());
		}
	});
	var feeOrder = dhcc.doc.feeOrder;
	var operateObj = dhcc.doc.getOperateProxy(feeOrder);	
	cancelFeeOrderHandler = function(b,e){
		var rtn = window.showModalDialog("dhcdoc.statuschreason.csp",{},"dialogHeight:400px;dialogWidth:600px;resizable:yes");
		if(rtn && rtn.comment){
			operateObj.sendAjax(b, e ,{act:'CancelFeeOrder',comment: rtn.comment});
		}
	}
	var clearStore = function(s, r){
		feeOrder.store.removeAll();
	}
	if(dhcc.doc.execOrder){	//
		dhcc.doc.execOrder.on("rowdblclick",function(g,num,e){
			var oeori = g.store.getAt(num).data["HIDDEN1"];
			feeOrder.refreshData({P1: oeori});
		});
		dhcc.doc.execOrder.store.on("load",clearStore);
		dhcc.doc.execOrder.store.on("clear",clearStore);		
	};
	/**
	*{HIDDEN2_Disable: ['R']}
	*/
	cancelFeeOrderShowHandler = function(record, rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		var pbdStatus = record.data["HIDDEN2"];
		if(pbdStatus == "R") {
			this.qtitle = "说明";
			this.qtip = "记录冲红过不能取消费用!";
			return false ;
		}
		return true;
	}
})