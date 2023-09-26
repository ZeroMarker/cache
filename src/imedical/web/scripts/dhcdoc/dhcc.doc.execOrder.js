/**!
* @author: wanghc
* @date:   2012-04-08
* @desc:   医嘱执行情况查询
* 用到dhcc.doc.OrderCenter.js内的dhcc.doc.getOperateProxy方法
*/
var runExecOrderHandler,stopExecOrderHandler,freeExecOrderHandler,cancelFreeExecOrderHandler,cancelExecOrderHandler,addFeeExecOrderHandler,UpdateHourOrderEndTimeHandler;
var runExecOrderShowHandler,stopExecPrnOrderShowHandler,stopExecSosOrderShowHandler,freeExecOrderShowHandler,cancelFreeExecOrderShowHandler;
var cancelExecOrderShowHandler,addFeeExecOrderShowHandler,UpdateHourOrderEndTimeShowHandler,IsHourOrder= false;
var IsMustApplyCancelText="",IsMustApplyCancelOrdexec=0;	//撤销执行时要不要做撤销申请
/*var dateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
if (dateFormat=="3"){
    dateFormat="Y-m-d"
}else if(dateFormat=="4"){
	dateFormat="d/m/Y"
}else{
	dateFormat="Y-m-d";
}*/
var dateFormat = websys_DateFormat
Ext.ns("dhcc.doc");
var NURPRNExec=tkMakeServerCall("web.DHCDocMain","GetNURPRNExec",session['LOGON.GROUPID']);
var GridPaneltbar=[{xtype:'textfield', id:'execBarOrderId', hidden:true},
			"执行日期 从 ",{xtype:'uxdatefield', format:dateFormat, id:'execBarExecStDate'},
			" 到 ",{xtype:'uxdatefield', format:dateFormat, id:'execBarExecEndDate'},
			'-',{text:'查询',id:'find'}]
if (NURPRNExec!="{}"){
	var operateMenu = new Ext.menu.Menu();
		operateMenu.add({
			text:"查询",
			id:"find"
		});
		operateMenu.add({
			text: '执行多条',
			id:"MultiExec",
			handler: function(b, e){
				runExecOrderHandler(b,e);
			}
		});
		operateMenu.add({
			text: '停止执行多条',
			id:"StopMultiExec",
			handler: function(b, e){
				stopExecOrderHandler(b,e);
			}
		});
		operateMenu.add({
			text: '撤销执行多条',
			id:"CamcelMultiExec",
			handler: function(b, e){
				cancelExecOrderHandler(b,e);
			}
		});
		
	GridPaneltbar=[{xtype:'textfield', id:'execBarOrderId', hidden:true},
			"执行日期 从 ",{xtype:'uxdatefield', format:dateFormat, id:'execBarExecStDate'},
			" 到 ",{xtype:'uxdatefield', format:dateFormat, id:'execBarExecEndDate'},"-",{text:"操作",
			menu:operateMenu}];
}
Ext.onReady(function(){
	Ext.QuickTips.init();
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var internalType = orderGridPanel.internalType;
	var orderType = orderGridPanel.orderType;
	dhcc.doc.execOrder = new dhcc.icare.MixGridPanel({
		title: "执行医嘱",
		defaultTitle: "执行医嘱",
		split: true,
		listClassName: 'web.DHCDocMain',
		listQueryName: 'FindOrderExecDet',
		columnModelFieldJson: window.execMetaDataJson || "",
		region: 'center',
		pageSize:20,
		hiddenCM: ["TExecStateCode"],
		ExecOrderId : 'HIDDEN1',
		ExecOrderSelectArr : [], //记录所有页的选中记录id	
		ExecOrderSelectObjs: [], //记录所有页的选中记录Index	
		cmHandler : function(cms){
			var len = cms.length, i, statuDesc = "TExecState",statuCode="TExecStateCode",  freeFlag = "TExecFreeChargeFlag";
			for( i = 0 ; i < len; i++){		
				if(cms[i].dataIndex == statuDesc){
					cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){					
						if( ["未执行","D","C"].indexOf(record.json[statuCode]) > -1 ){
							metaData.attr = "style='background-color: yellow;'";
							//return "<span style='background-color: yellow;'>"+value+"</span>";
						}
						return value;
					} 
				}else if(cms[i].dataIndex == freeFlag){			
					cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){								
						if("免费" == record.get(freeFlag)) metaData.attr = "style='background-color: #00FF00;'"; //return "<span style='background-color:#00FF00'>"+value+"</span>";
						return value;
					}		
				}else if(cms[i].dataIndex == "CustomSelected"){
						cms[i].width = 37;
						cms[i].fixed = true;
						if (NURPRNExec=="{}"){
							cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){
								return "";
								//this.columns[i].hide()//show()
							}
						}else{
							cms[i].header = "<input type='checkbox' id='checkboxhdExec' />";
							cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){
								return "<input type='checkbox' id='checkboxExec"+rowIndex+"' oeorigroup='" + value + "' />";
							}
						}
			    }
			}
			return cms;
		},
		selectAll: function(){
			var that = this;		
			this.store.each(function(r,i){				
				//if (runExecOrderShowHandler(r,i)){
					document.getElementById("checkboxExec"+i).checked = true;
					dhcc.doc.execOrder.getView().onRowSelect(i);
					that.RowSelect(this,i,r);
				//}
			});
		},
		deselectHd:	function(){
			document.getElementById("checkboxhdExec").checked = false;
		},
		deselectAll: function(){
			var that = this;
			this.store.each(function(r,i){
				that.ExecOrderSelectArr.remove(r.data[that.ExecOrderId]);
				that.ExecOrderSelectObjs.remove(r.data);
				document.getElementById("checkboxExec"+i).checked = false;
				dhcc.doc.execOrder.getView().onRowDeselect(i)
			});
		},
		onHdMouseDown : function(e,t){
			e.stopEvent();
			var flag = document.getElementById("checkboxhdExec").checked;
			if(flag===true){
				this.deselectAll();
			}else{
				this.selectAll();
			}
		},
		getSelectedRow : function(){
			var obj,rowrecord;		
			this.store.each(function(r,i){
				obj = document.getElementById("checkboxExec"+i);
				if(obj && obj.checked){
					rowrecord = r;
				}					
			})
			return rowrecord ;
		},
		getAllPageSelectedRowIds: function(){
		   return this.ExecOrderSelectArr.join("^");
	    },
	    /*获取所有选中行Index*/
		getAllPageSelectedRowObjs: function(){
			return this.ExecOrderSelectObjs //.join("^");
		},
		getSelectedRowIds : function(){
			var obj, ids = "" //, ExecOrderId = this.ExecOrderId;		
			this.store.each(function(r,i){
				obj = document.getElementById("checkboxExec"+i);
				if(obj && obj.checked){
					if("" == ids){ 
						ids = r.data["HIDDEN1"];
					}else{ 
						ids += "^" + r.data["HIDDEN1"];
					}
				}					
			})
			return ids ;
		},
		RowSelect:function(g, rowIndex,record){
			if (dhcc.doc.execOrder.ExecOrderSelectArr){
					dhcc.doc.execOrder.ExecOrderSelectArr.remove(record.data["HIDDEN1"]);		//清除选中
			        dhcc.doc.execOrder.ExecOrderSelectObjs.remove(record.data);		//清除选中
				}
				/*setTimeout(function(){
					document.getElementById("checkboxExec"+rowIndex).checked = true;
				}, 500); */
				
				dhcc.doc.execOrder.ExecOrderSelectArr.push(record.data["HIDDEN1"]);
				dhcc.doc.execOrder.ExecOrderSelectObjs.push(record.data);
		},
		initEvents: function(){
			this.on("rowcontextmenu", this.rowContextMenuHandler);
			this.getSelectionModel().on("rowselect",this.RowSelect);
			this.on("headerdblclick",this.headerDblClick);
			var obj=document.getElementById("checkboxhdExec");
			if (obj){
				Ext.fly("checkboxhdExec").on("mousedown",this.onHdMouseDown,this);
			}
			var that = this;
			this.store.on("load",function(s,rs){
				var storeCount = s.getCount();
				s.each(function(r,i){
					var cbobj = document.getElementById("checkboxExec"+i);
					Ext.EventManager.addListener(cbobj,"click",function(evt,t,obj){
						that.ExecOrderSelectArr.remove(r.data["HIDDEN1"]);
						that.ExecOrderSelectObjs.remove(r.data);
						if(cbobj.checked==true){
							that.ExecOrderSelectArr.push(r.data["HIDDEN1"]);
							that.ExecOrderSelectObjs.push(r.data);
							dhcc.doc.execOrder.getView().onRowSelect(i);
						}else{
							dhcc.doc.execOrder.getView().onRowDeselect(i)
						}
					})
					
				})
			});
		},
		tbar:GridPaneltbar,
		rowContextMenuHandler:function(g,rowIndex,e){
			e.stopEvent();		
			g.getSelectionModel().selectRow(rowIndex);
			var r = g.store.getAt(rowIndex);
			//处理勾选 start
			this.deselectHd();
			this.deselectAll();
			//if (runExecOrderShowHandler(r,rowIndex)){
				this.ExecOrderSelectArr.remove(r.data[this.ExecOrderId]);		//清除选中
				this.ExecOrderSelectObjs.remove(r.data);		//清除选中
				document.getElementById("checkboxExec"+rowIndex).checked = true;
				this.ExecOrderSelectArr.push(r.data[this.ExecOrderId]);
			    this.ExecOrderSelectObjs.push(r.data);
			//}
			//处理勾选  end
			var rightKeyMenu=g.rightKeyMenu
			if(execOrder.Priority){
				if(execOrder.Priority.indexOf("长期")>=0){
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
	var execOrder = dhcc.doc.execOrder;	
	var operateObj = dhcc.doc.getOperateProxy(execOrder);
	runExecOrderHandler = function(b, e ){
		var titlePre = "执行记录时间";
		if (b.id=="MultiExec"){
			titlePre = "执行多条记录时间";
		}
		var rowrecord = execOrder.getSelectedRow();
		var oeoreRowObjs=execOrder.getAllPageSelectedRowObjs();
		var oeoreis = execOrder.getAllPageSelectedRowIds();
		if(oeoreis==""){
			if(!rowrecord){
			  Ext.Msg.alert("提示","没有选中记录!");
			   return ;	
		    }
			oeoreis=rowrecord.data["HIDDEN1"];
		}
		if (oeoreis==""){
			Ext.Msg.alert("提示","没有选中记录!");
			return ;
		}
		var oeoreisArr=oeoreis.split("^");
		for (var i=0;i<oeoreisArr.length;i++){
			var oeorerowid=oeoreisArr[i]; 
			var flag=tkMakeServerCall("web.DHCDocMainOrderInterface","IsCanExecOrdArrear","",oeorerowid,session['LOGON.CTLOCID'])
            var TExStDate=oeoreRowObjs[i]["TExStDate"];
            if (flag=="NotCF"){
	            Ext.Msg.alert("提示",TExStDate+"只有未执行与撤销执行的执行记录才能执行!");
				return false;
	        }else if(flag=="U"){
		        Ext.Msg.alert("提示","医嘱已作废,不能执行!");
				return false;
		    }else if(flag=="P"){
		        Ext.Msg.alert("提示","医嘱Pre-Order,不能执行!");
				return false;
		    }else if(flag=="I"){
		        Ext.Msg.alert("提示","医嘱未核实,不能执行!");
				return false;
		    }else if(flag=="FeeNotEnough"){
		        Ext.Msg.alert("提示",TExStDate+"费用不足,不能执行!");
				return;
		    }else if(flag=="SkinAbnorm"){
		        Ext.Msg.alert("提示","皮试医嘱结果为阳性,不能执行!");
				return false;
		    }else if(flag=="DrugSubOrder"){
		        Ext.Msg.alert("提示","药品子医嘱,不能执行!");
				return false;
		    }else if(flag=="NotSeeOrd"){
				Ext.Msg.alert("提示","医嘱未处理,不能执行!");
				return false;		
			}else if(flag=="NotIPMonitorRtn"){
				Ext.Msg.alert("提示","药品审核不通过,不能执行!");
				return false;		
			}
		}
		var now = new Date()
		var Hours=now.getHours();
		var Minutes=now.getMinutes()
		if (Hours >= 1 && Hours <= 9) {
           Hours = "0" + Hours;
        }
	    if (Minutes >= 0 && Minutes <= 9) {
	        Minutes = "0" + Minutes;
	    }
		var nowTime = Hours+":"+Minutes;
		var minTime=nowTime;
		if (oeoreisArr.length==1){
			var ExeStDate=oeoreRowObjs[0]["TExStDate"];
			var ExeStTime = ExeStDate.split(" ")[1];
			var ExeStDate = ExeStDate.split(" ")[0];
			if (dateFormat=="Y-m-d"){
				var ExeStMonth = parseInt(ExeStDate.split("-")[0]) - 1;
			    var ExeStDay = parseInt(ExeStDate.split("-")[1]);
			}
			if (dateFormat=="d/m/Y"){
				var ExeStMonth = parseInt(ExeStDate.split("/")[1]) - 1;
			    var ExeStDay = parseInt(ExeStDate.split("/")[0]);
			}
			if ((now.getMonth() == ExeStMonth) && (now.getDate()==ExeStDay)){
				minTime = ExeStTime; 
			}
		}
		var win = new Ext.Window({					
			title: titlePre, layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign: 'right',
			items: [
				{xtype: 'uxdatefield', id:'execDate',value:now, fieldLabel:'执行日期', width:160,allowBlank: false,format:dateFormat},				
				{xtype: 'timefield', id:'execTime',value:minTime, fieldLabel:'执行时间', width:160,allowBlank: false,format:'H:i:s',minValue:minTime}		
			],
			buttons: [{
				text:'更新',
				iconCls:'icon-update-custom',
				handler: function(t,e){						
						var execTime = Ext.fly("execTime").dom.value;
						var execDate = Ext.fly("execDate").dom.value;
						if (execTime == ''){
							Ext.Msg.alert("提示","请填写时间!");
							return 
						}
						var nowMonth=parseInt(now.getMonth())+1;
						var nowDate=now.getDate();
						
						for (var i=0;i<oeoreisArr.length;i++){
							var TExeStDate=oeoreRowObjs[i]["TExStDate"];
							var ExeStTime = TExeStDate.split(" ")[1];
							var ExeStDate = TExeStDate.split(" ")[0];
							if (dateFormat=="Y-m-d"){
								var ExeStMonth = parseInt(ExeStDate.split("-")[0]);
							    var ExeStDay = parseInt(ExeStDate.split("-")[1]);
							    var execMonth = parseInt(execDate.split("-")[0]);
							    var execDate1 =parseInt(execDate.split("-")[1]);
							}
							if (dateFormat=="d/m/Y"){
								var ExeStMonth = parseInt(ExeStDate.split("/")[1]);
							    var ExeStDay = parseInt(ExeStDate.split("/")[0]);
							    var execMonth = parseInt(execDate.split("/")[1]);
							    var execDate1 =parseInt(execDate.split("/")[0]);
							}
							var currFlag = false;
							var minTime = "00:00";
							//if ((now.getMonth() == ExeStMonth) && (now.getDate()==ExeStDay)){
							if ((nowMonth==ExeStMonth)&&(nowDate==ExeStDay)&&(nowMonth=execMonth)&&(nowDate==execDate1)){
								currFlag = true;	
								minTime = ExeStTime; //当天不能小于要求执行时间 
							}
							if (currFlag && (execTime<ExeStTime)){
								Ext.Msg.alert("提示",TExeStDate+"执行时间不得小于要求时间("+ExeStTime+")!");
							    return 
							}
							operateObj.sendAjax(b, e, {act:'RunExecOrder',execDate: execDate,execTime: execTime,rid:oeoreisArr[i]});
						}
						
						win.close();
					}
				},{ text:'返回',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});		
		win.show();
		Ext.getCmp("execTime").focus(true,100);
		
		
		/*执行执行记录时,可以填写时间*/
		/*var r = execOrder.getSelectionModel().getSelected();
		var ExeStDate = r.data["TExStDate"];
		var ExeStTime = ExeStDate.split(" ")[1];
		var ExeStDate = ExeStDate.split(" ")[0];
		var ExeStMonth = parseInt(ExeStDate.split("-")[0]) - 1;
		var ExeStDay = parseInt(ExeStDate.split("-")[1]);
		var now = new Date(),currFlag = false;
		var nowTime = now.getHours()+":"+now.getMinutes();
		var minTime = "00:00";
		if ((now.getMonth() == ExeStMonth) && (now.getDate()==ExeStDay)){
			currFlag = true;	
			minTime = ExeStTime; //当天不能小于要求执行时间 
		}
		if(!r){Ext.Msg.alert("提示","没有选中记录!");return;}
		var win = new Ext.Window({					
			title: titlePre, layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign: 'right',
			items: [				
				{xtype: 'timefield', id:'execTime',value:nowTime, fieldLabel:'执行时间', width:160,allowBlank: false,format:orderGridPanel.timeFormat,minValue:minTime}		
			],
			buttons: [{
				text:'更新',
				handler: function(t,e){						
						var execTime = Ext.fly("execTime").dom.value;
						if (execTime == ''){
							Ext.Msg.alert("提示","请填写时间!");
							return 
						}
						if (currFlag && (execTime<ExeStTime)){
							Ext.Msg.alert("提示","执行时间不得小于要求时间("+ExeStTime+")!");
							return 
						}
						operateObj.sendAjax(b, e, {act:'RunExecOrder',execTime: execTime});
						win.close();
					}
				},{ text:'返回',handler: function(t,e){ win.close();}
			}]				
		});		
		win.show();
		Ext.getCmp("execTime").focus(true,100);*/
		/*Ext.Msg.confirm('提示', '确定 ' + b.text+ ' 吗?', function(btn, text){;	
			if(btn == 'yes'){ operateObj.sendAjax(b, e, {act:'RunExecOrder'});} 
		});		*/
	};
	stopExecOrderHandler = function(b, e ){
		// Ext.Msg.confirm('提示', '确定 ' + b.text+ ' 吗?', function(btn, text){;	
			// if(btn == 'yes'){ operateObj.sendAjax(b, e, {act:'StopExecOrder'});} 
		// });
	    var rowrecord = execOrder.getSelectedRow();
		var oeoreRowObjs=execOrder.getAllPageSelectedRowObjs();
		var oeoreis = execOrder.getAllPageSelectedRowIds();
		if(oeoreis==""){
			if(!rowrecord){
			  Ext.Msg.alert("提示","没有选中记录!");
			   return ;	
		    }
			oeoreis=rowrecord.data["HIDDEN1"];
		}
		if (oeoreis==""){
			Ext.Msg.alert("提示","没有选中记录!");
			return ;
		}
		var oeoreisArr=oeoreis.split("^");
		for (var i=0;i<oeoreisArr.length;i++){
			var oeorerowid=oeoreisArr[i]; 
            var TExStDate=oeoreRowObjs[i]["TExStDate"];
            if (["3","4","5"].indexOf(patData.patFlag)>-1){
	            Ext.Msg.alert("提示","病人已"+patData.flagDesc+"!");
				return false;
		    }
		    var execStatus = oeoreRowObjs[i]["TExecStateCode"];
		    var orderStatCode = oeoreRowObjs[i]["HIDDEN2"];
		    if(execStatus != "C" && execStatus != "未执行") {
			    Ext.Msg.alert("提示",TExStDate+"只有未执行与撤销执行的执行记录才能停止!");
				return false;
			}
			if(orderStatCode=="U"){
				Ext.Msg.alert("提示","医嘱已作废!");
				return false;
			}
			if(orderStatCode=="P"){
				Ext.Msg.alert("提示","医嘱Pre-Order!");
				return false;
			}
			if(orderStatCode=="I"){
				Ext.Msg.alert("提示","医嘱未核实!");
				return false;
			}
			if(orderStatCode=="C"){
				Ext.Msg.alert("提示","医嘱撤销!");
				return false;
			}
			/*if(orderStatCode=="D"){
				Ext.Msg.alert("提示","医嘱已停止!");
				return false;
			}*/
		}
		var rtn = window.showModalDialog("dhcdoc.statuschreason.csp",{},"dialogHeight:400px;dialogWidth:600px;resizable:yes");
		var obj ;
		if(rtn && rtn.comment){
			for (var i=0;i<oeoreisArr.length;i++){
				operateObj.sendAjax(b, e, {act:'StopExecOrder',reasonId: rtn.reasonId,rid:oeoreisArr[i],Reasoncomment:rtn.comment});
			}
			//operateObj.sendAjax(b, e, {act:'StopExecOrder',reasonId: rtn.reasonId});
		}
	};
	freeExecOrderHandler = function(b, e ){
		// Ext.Msg.confirm('提示', '确定 ' + b.text+ ' 吗?', function(btn, text){;	
			// if(btn == 'yes'){ operateObj.sendAjax(b, e, {act:'FreeCharge'});} 
		// });	
		var rtn = window.showModalDialog("dhcdoc.statuschreason.csp",{},"dialogHeight:400px;dialogWidth:600px;resizable:yes");
		var obj ;
		if(rtn && rtn.comment){
			operateObj.sendAjax(b, e, {act:'FreeCharge',reasonId: rtn.reasonId});
		}		
	};
	cancelFreeExecOrderHandler = function(b, e ){
		// Ext.Msg.confirm('提示', '确定 ' + b.text+ ' 吗?', function(btn, text){;	
			// if(btn == 'yes'){ operateObj.sendAjax(b, e, {act:'CancelFreeCharge'});} 
		// });	
		var rtn = window.showModalDialog("dhcdoc.statuschreason.csp",{},"dialogHeight:400px;dialogWidth:600px;resizable:yes");
		var obj ;
		if(rtn && rtn.comment){
			operateObj.sendAjax(b, e, {act:'CancelFreeCharge',reasonId: rtn.reasonId});
		}		
	};
	cancelExecOrderHandler = function (b,e){
		var rowrecord = execOrder.getSelectedRow();
		var oeoreRowObjs=execOrder.getAllPageSelectedRowObjs();
		var oeoreis = execOrder.getAllPageSelectedRowIds();
		if(oeoreis==""){
			if(!rowrecord){
			  Ext.Msg.alert("提示","没有选中记录!");
			   return ;	
		    }
			oeoreis=rowrecord.data["HIDDEN1"];
		}
		if (oeoreis==""){
			Ext.Msg.alert("提示","没有选中记录!");
			return ;
		}
		var oeoreisArr=oeoreis.split("^");
		for (var i=0;i<oeoreisArr.length;i++){
			var oeorerowid=oeoreisArr[i]; 
            var TExStDate=oeoreRowObjs[i]["TExStDate"];
            if (["3","4","5"].indexOf(patData.patFlag)>-1){
	            Ext.Msg.alert("提示","病人已"+patData.flagDesc+"!");
				return false;
		    }
		    var execStatus = oeoreRowObjs[i]["TExecStateCode"];
		    var orderStatCode = oeoreRowObjs[i]["HIDDEN2"];
		    if(execStatus != "F") {
			    Ext.Msg.alert("提示",TExStDate+"已执行的才能撤销!");
				return false;
			}
			if(orderStatCode=="E"){
				Ext.Msg.alert("提示",TExStDate+"医嘱状态为执行不能撤销执行!");
				return false;
			}
			var applyCancelStatusCode = oeoreRowObjs[i]["TApplyCancelStatusCode"];
			if (applyCancelStatusCode=="A"){
				Ext.Msg.alert("提示",TExStDate+"已申请撤销,请等待审核!");
				return false;
			}
			if(oeoreRowObjs[i]["IsCancelArrivedOrd"]==0){
				Ext.Msg.alert("提示",TExStDate+"治疗记录已经治疗,不能撤销执行!");
				return false;
		    }
		}
		//Modal
		var rtn = window.showModalDialog("dhcdoc.statuschreason.csp",{},"dialogHeight:400px;dialogWidth:600px;resizable:yes");
		var obj ;
		if(rtn && rtn.comment){
			for (var i=0;i<oeoreisArr.length;i++){
				operateObj.sendAjax(b, e, {act:'CancelExecOrder',reasonId: rtn.reasonId,rid:oeoreisArr[i],Reasoncomment:rtn.comment});
			}
			//operateObj.sendAjax(b, e, {act:'CancelExecOrder',reasonId: rtn.reasonId});
		}
	}
	addFeeExecOrderHandler = function( b, e){
		var rtn = window.showModalDialog("dhcdoc.addmodalfee.csp",{},"dialogHeight:400px;dialogWidth:600px;resizable:yes");
		if(rtn && rtn.itemInfo){
			var callbackFun = function(resp,opts){
				var rtn = resp.responseText.replace(/\r\n/g,"");
				try{var obj = Ext.decode(rtn);}catch(e){alert("操作失败!");return ;}
				if (obj.msg == "0"){					
					var startIndex = dhcc.doc.feeOrder.getBottomToolbar().cursor;
					dhcc.doc.feeOrder.store.load({params:{start: startIndex}});
				}else{
					Ext.Msg.alert("提示","失败!<br>代码: " + obj.msg);
				}	
			};	
			operateObj.sendAjax(b, e, {act:'AddFeeOrder',itemInfo: rtn.itemInfo},callbackFun);			
		}
	}
	UpdateHourOrderEndTimeHandler = function(b, e){
		var r = execOrder.getSelectionModel().getSelected();
		if(!r){Ext.Msg.alert("提示","没有选中记录!");return;}
		var ids = r.data["HIDDEN1"];		
		//var rtn = tkMakeServerCall("web.DHCDocMain","CheckUpdateHour",ids,"");
		//if(rtn!=1){Ext.Msg.alert("提示",rtn);return;}
		//{xtype: 'timefield', id: 'endTime', fieldLabel:'结束时间', width:160,allowBlank: false,format:orderGridPanel.timeFormat}
		var win = new Ext.Window({					
			title: '修改小时医嘱时间', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign: 'right',
			items: [				
				{xtype: 'timefield', id: 'endTime', fieldLabel:'结束时间', width:160,allowBlank: false,format:"H:i:s"}			
			],
			buttons: [{
				text:'更新',
				iconCls:'icon-update-custom',
				handler: function(t,e){						
						var endTime = Ext.fly("endTime").dom.value;
						if (endTime == ''){
							Ext.Msg.alert("提示","请填写时间!");
							return 
						}
						operateObj.sendAjax(b, e, {act:'UpdateHourOrderEndTime',endTime: endTime});
						win.close();
					}
				},{ text:'返回',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});		
		win.show();
		Ext.getCmp("endTime").focus(true,100);
	}
	NuraddOrderNotesHandler = function(b, e){
		var r = execOrder.getSelectionModel().getSelected();
		var proNote = tkMakeServerCall("appcom.OEOrdExec","GetOEORIExecNotes",r.data["HIDDEN1"]);
		var win = new Ext.Window({					
			title: '增加备注', layout: 'form',					
			width: 330, height: 230, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'textarea', id: 'OrderNotes', fieldLabel:"备注",labelStyle: 'width:50px;', width:200,height:120,allowBlank: false,value:proNote}		
			],
			buttons: [{
				text:'确定',iconCls:'icon-ok-custom',handler: function(t,e){								
						var OrderNotes = Ext.getCmp("OrderNotes").getValue();
						if (OrderNotes == ''){
							Ext.Msg.alert("提示","备注为空，请填写");
							return 
						}
						operateObj.sendAjax(b, e, {act:'NURAddOrderNotes',OrderNotes: OrderNotes});
						win.close();
					}
				},{ text:'返回',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("OrderNotes").focus(100);
	};	

	var oeoriTF = Ext.getCmp("execBarOrderId");
	var stDF = Ext.getCmp("execBarExecStDate");
	var endDF = Ext.getCmp("execBarExecEndDate");
	var findB = Ext.getCmp("find");
	if (findB) {
		findB.on("click", function(b,e){
			var oeori = oeoriTF.getValue();
			var st = stDF.getRawValue();
			var end = endDF.getRawValue();
			dhcc.doc.execOrder.refreshData({P1: oeori, P2: st, P3: end});			
		});
	}
	/*var MultiExecB = Ext.getCmp("MultiExec");
	if (MultiExecB) {
		MultiExecB.on("click", function(b,e){
			runExecOrderHandler(b,e);		
		});
	}*/
	
	var clear = function(){
		oeoriTF.setValue("");
		stDF.setValue("");
		endDF.setValue("");
		dhcc.doc.execOrder.setTitle(dhcc.doc.execOrder.defaultTitle);	
	};
	var clearStore = function(s, r){
		clear();
		execOrder.store.removeAll();
	};
	if(orderGridPanel){
		orderGridPanel.on("rowdblclick",function(g,num,e){	
            execOrder.ExecOrderSelectArr.length = 0; //操作后清空选中
		    execOrder.ExecOrderSelectObjs.length = 0; //操作后清空选中		
			var data = g.store.getAt(num).data;
			var oeori = data[g.orderId];
			var dd = new Date();
			var nowdate = dd.format("Y-m-d");
			dd.setDate(dd.getDate()+1);
			var tomorrow = dd.format("Y-m-d");
 			IsHourOrder = data["TBillUom"]=="HOUR" ? true : false;
			oeoriTF.setValue(oeori);
			IsMustApplyCancelOrdexec = tkMakeServerCall("web.DHCApplication","IsMustApplyCancel",oeori);
			execOrder.Priority=data["Priority"]
			//更新日期范围
			Ext.Ajax.request({
				url: operateObj.url,
				success: function(resp,opts){
					var rtn = resp.responseText.replace(/\r\n/g,"");
					var obj;
					try{
						obj = Ext.decode(rtn);
					}catch(e){
						Ext.Msg.alert("提示","后台操作失败!");
						clear();				
						return ;
					}
					var arr = obj.msg.split("^");
					if(arr.length>1){
						if(orderGridPanel.orderType== "PRN"){
							stDF.setValue(arr[0]);
							endDF.setValue(tomorrow);
						}else{						
							stDF.setValue(arr[0]);
							endDF.setValue(arr[1]);
						}
						execOrder.setTitle(arr[2]);
					}
					execOrder.refreshData({P1: oeori, P2: stDF.getValue(), P3: endDF.getValue()});
				},
				failure: function(resp,opts){ clear(); },		
				params: {act: 'getExecDateScope', rid: oeori}
			});
		})
		orderGridPanel.store.on("load", clearStore);
		orderGridPanel.store.on("clear",clearStore);
	};
	//申请中与拒绝的变色
	var execLoadEvtHandler = function(s,rs){
		s.each(function(r,i){
			if(r.data["TApplyCancelStatusCode"]=="A"){
				dhcc.doc.execOrder.getView().getRow(i).style.backgroundColor="#60f807" ;//'#00ccff';
			}
			if(r.data["TApplyCancelStatusCode"]=="R"){
				dhcc.doc.execOrder.getView().getRow(i).style.backgroundColor="#60f807" ;//'#00ccff';
			}
		});
	};
	dhcc.doc.execOrder.store.on("load",execLoadEvtHandler);
	/**
	*{TExecStateCode_Display:['未执行','C'],HIDDEN2_Disabled:['U','P','I']}
	*/
	runExecOrderShowHandler = function(record,rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		var execStatus = record.data["TExecStateCode"];
		var orderStatCode = record.data["HIDDEN2"];
		var IsCanExecOrdArrear = record.data["IsCanExecOrdArrear"];
		if(execStatus != "C" && execStatus != "未执行") {
			this.qtitle = "说明";
			this.qtip = "只有未执行与撤销执行的执行记录才能执行!";
			return false ;
		}else if(orderStatCode == "U"){
			this.qtitle = "说明";
			this.qtip = "医嘱已作废!";
			return false ;
		}else if(orderStatCode == "P"){
			this.qtitle = "说明";
			this.qtip = "医嘱Pre-Order!";
			return false ;
		}else if(orderStatCode == "I"){
			this.qtitle = "说明";
			this.qtip = "医嘱未核实!";
			return false ;
		}else if(IsCanExecOrdArrear=="FeeNotEnough"){
			this.qtitle = "说明";
			this.qtip = "费用不足,不能执行!";
			return false ;
		}else if("SkinAbnorm"==IsCanExecOrdArrear){
			this.qtitle = "说明";
			this.qtip = "皮试医嘱结果为阳性,不能执行!";
			return false;
		}else if("DrugSubOrder"==IsCanExecOrdArrear){
			this.qtitle = "说明";
			this.qtip = "药品子医嘱不允许执行!";
			return false;		
		}else if("NotSeeOrd"==IsCanExecOrdArrear){
			this.qtitle = "说明";
			this.qtip = "医嘱未处理,不能执行! ";
			return false;		
		}else if("NotIPMonitorRtn"==IsCanExecOrdArrear){
			this.qtitle = "说明";
			this.qtip = "药品审核不通过,不能执行! ";
			return false;		
		}else if("PlacerNo"==IsCanExecOrdArrear){
			//this.qtitle = "说明";
			//this.qtip = "检验医嘱未扫条码,不允许执行!";
			//return false;
		}			
		return true;  
	};
	/**
	*{TExecStateCode_Display:['未执行','C'],HIDDEN2_Disabled:['U','P','I']}	
	*/
	stopExecPrnOrderShowHandler = function(record,rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		var execStatus = record.data["TExecStateCode"];
		var orderStatCode = record.data["HIDDEN2"];
		if(execStatus != "C" && execStatus != "未执行") {
			this.qtitle = "说明";
			this.qtip = "只有未执行与撤销执行的执行记录才能停止!";
			return false ;
		}else if(orderStatCode == "U"){
			this.qtitle = "说明";
			this.qtip = "医嘱已作废!";
			return false ;
		}else if(orderStatCode == "P"){
			this.qtitle = "说明";
			this.qtip = "医嘱Pre-Order!";
			return false ;
		}else if(orderStatCode == "I"){
			this.qtitle = "说明";
			this.qtip = "医嘱未核实!";
			return false ;
		}			
		return true;
	};
	/**
	*{TExecStateCode_Display:['未执行','C'],HIDDEN2_Display: ['D','C','U']}
	*/
	stopExecSosOrderShowHandler = function(record,rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		var execStatus = record.data["TExecStateCode"];
		var orderStatCode = record.data["HIDDEN2"];
		if(execStatus != "C" && execStatus != "未执行") {
			this.qtitle = "说明";
			this.qtip = "只有未执行与撤销执行的执行记录才能停止!";
			return false ;
		}else if(orderStatCode == "U"){
			this.qtitle = "说明";
			this.qtip = "医嘱已作废!";
			return false ;
		}else if(orderStatCode == "C"){
			this.qtitle = "说明";
			this.qtip = "医嘱撤销!";
			return false ;
		}else if(orderStatCode == "D"){
			this.qtitle = "说明";
			this.qtip = "医嘱已停止!";
			return false ;
		}			
		return true;
	};
	/**
	*{TExecFreeChargeFlag_Disabled: ['免费'],HIDDEN2_Disabled:['U','P','I']}	
	*/
	freeExecOrderShowHandler = function(record, rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		var execStatus = record.data["TExecFreeChargeFlag"];
		var orderStatCode = record.data["HIDDEN2"];
		if(execStatus == "免费") {
			this.qtitle = "说明";
			this.qtip = "记录已免费过!";
			return false ;
		}else if(orderStatCode == "U"){
			this.qtitle = "说明";
			this.qtip = "医嘱已作废!";
			return false ;
		}else if(orderStatCode == "P"){
			this.qtitle = "说明";
			this.qtip = "医嘱Pre-Order!";
			return false ;
		}else if(orderStatCode == "I"){
			this.qtitle = "说明";
			this.qtip = "医嘱未核实!";
			return false ;
		}			
		return true;
	};
	/**
	*	{TExecFreeChargeFlag_Display: ['免费']}
	*/
	cancelFreeExecOrderShowHandler = function(record, rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		var execStatus = record.data["TExecFreeChargeFlag"];
		if(execStatus != "免费") {
			this.qtitle = "说明";
			this.qtip = "免费过才能取消免费!";
			return false ;
		}
		return true;
	};
	/**
	*{TExecStateCode_Display: ['F']}
	*/
	cancelExecOrderShowHandler = function(record, rowIndex){		
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		var execStatus = record.data["TExecStateCode"];
		var orderStatCode = record.data["HIDDEN2"];
		var orgText = this.text;
		if(orgText.indexOf("申请")!=-1){
			orgText = orgText.slice(2);
		}
		if(IsMustApplyCancelOrdexec==1){
			IsMustApplyCancelText = "申请"+orgText;
		}else{
			IsMustApplyCancelText = orgText;
		}		
		this.setText(IsMustApplyCancelText);
		if(execStatus != "F") {
			this.qtitle = "说明";
			this.qtip = "已执行的才能撤销!";
			return false ;
		}
		if(orderStatCode=="E"){
			this.qtitle = "说明";
			this.qtip = "医嘱状态为执行不能撤销执行！!";
			return false ;
		}
		var applyCancelStatusCode = record.data["TApplyCancelStatusCode"];
		if (applyCancelStatusCode=="A"){
			this.qtitle = "说明";
			this.qtip = "已申请撤销,请等待审核!";
			return false;
		}
		if(record.data["IsCancelArrivedOrd"]==0){
			this.qtitle = "说明";
			this.qtip = "治疗记录已经治疗,不能撤销执行!";
			return false;
		}
		return true;
	};
	/**
	*{TExecStateCode_Display:['F']}
	*/
	addFeeExecOrderShowHandler = function(record, rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		var execStatus = record.data["TExecStateCode"];
		if(execStatus != "F") {
			this.qtitle = "说明";
			this.qtip = "已执行的才能增加费用!";
			return false ;
		}
		return true;
	};
	/**
	*{HIDDEN2_Display: ['D']}
	*/
	UpdateHourOrderEndTimeShowHandler = function(record, rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		if(orderStatus != "D") {
			this.qtitle = "说明";
			this.qtip = "医嘱停止后才能修改时间!";
			return false ;
		}
		if(!IsHourOrder){
			this.qtitle = "说明";
			this.qtip = "不是小时医嘱!";
			return false ;
		}
		return true;
	};
	
})