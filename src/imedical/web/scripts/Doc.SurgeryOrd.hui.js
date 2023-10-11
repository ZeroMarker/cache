var PageLogicObj={
	m_SurgeryOrdTabDataGrid:"",
};
var GridParams={
    "papmi":ServerObj.PatientID,"adm":ServerObj.EpisodeID,"doctor":"0"
    ,"scope":"3","stloc":"1","nursebill":"ALL","inputOrderDesc":"",
    "ClassName":"web.DHCDocSosOrder","QueryName":"FindSosOrderFSNurse"
}
$(function(){
	//页面数据初始化
	Init();
	//页面元素初始化
	PageHandle();
	//事件初始化
	InitEvent();
	LoadPatOrdDataGrid();
});
function Init(){
	PageLogicObj.m_SurgeryOrdTabDataGrid=InitSurgeryOrdTabDataGrid();
}
function PageHandle(){
	InitdoctorList();
	InitscopeDesc();
	InitlocDesc();
}
function InitEvent(){
	$('#orderDesc').keydown(function(e){
		if(e.keyCode==13){
			GridParams.inputOrderDesc=e.target.value;
			LoadPatOrdDataGrid();
		}
   });
   $(document.body).bind("keydown",BodykeydownHandler)
}
function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    } 
}
var selRowIndex="";
function InitSurgeryOrdTabDataGrid(){
	    //w ##class(web.DHCDocMain).isHiddenMenu(1258,1)
		var flag=$.cm({
			ClassName:"web.DHCDocMain",
			MethodName:"isHiddenMenu",
		    adm:ServerObj.EpisodeID,
		    ctloc:session['LOGON.CTLOCID'],
			dataType:"text"
		},false);
		if ((flag!="0")&&(flag!="2")){
			var OrdToolBar="";
		}else{
			if (ServerObj.PAAdmType=="I"){
				var OrdToolBar=[{
		            text: '撤销',
		            iconCls: 'icon-cancel-order',
		            handler: function() {ShowCancelMulOrdWin();}
		        },{
		            text: '作废',
		            iconCls: 'icon-abort-order',
		            handler: function() {ShowUnUseMulOrdWin();}
		        }];
			}else{
				var OrdToolBar=[{
		            text: '撤销',
		            iconCls: 'icon-cancel-order',
		            handler: function() {ShowCancelMulOrdWin();}
		        }];
	        }
		}
			
		
		var reg1=/<[^<>]+>/g;
		var reg2=/&nbsp/g;
		var OrdColumns=[[ 
		 			{field:'CheckOrd',title:'选择',checkbox:'true',align:'center',width:70,auto:false},
		 			{field:'TStDate',title:'日期',align:'center',width:90,auto:false},
		 			{field:'TStTime',title:'时间',align:'center',width:65,auto:false},
		 			{field:'TOrderDesc',title:'医嘱',align:'left',width:350,auto:false,
		 				formatter: function(value,row,index){
			 				var inparaOrderDesc=$("#orderDesc").val();
			 				if (inparaOrderDesc!=""){
								value = value.replace(inparaOrderDesc,"<font color=red>"+inparaOrderDesc+"</font>");
							}
							var ordtitle=value 
							return '<a class="editcls-TOrderDesc" id= "' + row["HIDDEN"] + '"onmouseover="ShowOrderDescDetail(this)">'+ordtitle+'</a>';
		 				}
		 			},
		 			{field:'billqty',title:'数量',align:'center',width:80,auto:false},
		 			{field:'ArcPrice',title:'单价',align:'right',width:80,auto:false},
		 			{field:'OrderSum',title:'总金额',align:'right',width:80,auto:false},
		 			{field:'TDoctor',title:'开医嘱人',align:'center',width:80,auto:false},
		 			{field:'TNurse',title:'停止处理护士',align:'center',width:80,auto:false},
		 			{field:'TStopDate',title:'撤销日期',align:'center',width:120,auto:false,
		 				styler: function(value,row,index){
			 				if ((value!="")&&(value!=" ")){
				 				var stopDate=value.split(" ")[0];
				 				if (stopDate>ServerObj.CurrentDate){
					 				return 'background-color:yellow';
					 			}
				 			}
			 			}
		 			},
		 			{field:'TStopTime',title:'撤销时间',align:'center',width:120,auto:false},
		 			{field:'TItemStatDesc',title:'状态',align:'center',width:80,auto:false},
		 			{field:'TdeptDesc',title:'开单科室',align:'center',width:120,auto:false},
		 			{field:'TRecDepDesc',title:'接收科室',align:'center',width:120,auto:false},
		 			{field:'HIDDEN',title:'医嘱ID',align:'center',width:120,auto:false,
		 				formatter:function(value,rec){  
		                   var btn = '<a class="editcls" onclick="ordDetailInfoShow(\'' + rec.HIDDEN + '\')">'+value+'</a>';
					       return btn;
                        }
		 			},
		 			{field:'OrderType',title:'医嘱子类类型',align:'center',width:90,auto:false},
		 			{field:'MaterialBarCode',title:'材料条码',align:'center',width:90,auto:false},
		 			{field:'TBillUom',title:'计价单位',align:'center',width:80,auto:false},
		 			{field:'GroupSign',title:'组符号',align:'center',width:80,auto:false,
		 			 	styler: function(value,row,index){
			 			 	return 'color:red;';
		 			 	}
		 			},
		 			{field:'StopPermission',title:'是否可停止',width:30,auto:false,hidden:true},
		 			{field:'CancelPermission',title:'是否可撤销',width:30,auto:false,hidden:true},
		 			{field:'UnusePermission',title:'是否可作废',width:30,auto:false,hidden:true}
		 	]]
		SurgeryOrdTabDataGrid=$("#SurgeryOrdTab").datagrid({
			fit : true,
			width:1500,
			border : false,
			striped : true,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : false,
			autoSizeColumn : false,
			rownumbers:true,
			pagination : true,  //
			rownumbers : true,  //
			pageSize: 10,
			pageList : [10,100,200],
			idField:'HIDDEN',
			columns :OrdColumns,
			toolbar :OrdToolBar,
			onClickRow:function(rowIndex, rowData){
			},
			rowStyler:function(rowIndex, rowData){
	 			if (rowData.ColorFlag=="1"){
		 			return 'color:#788080;';
		 		}else if((rowData.TOeoriOeori=="")&&(rowData.GroupSign!="")){
			 		return 'background-color:#60F807;';
			 	}
			},
			onDblClickRow:function(rowIndex, rowData){
				//OrdDataGridDbClick(rowIndex, rowData);
			},
			onRowContextMenu:function(e, rowIndex, rowData){
				//ShowGridRightMenu(e,rowIndex, rowData,"Ord");
			},
			onCheck:function(rowIndex, rowData){
				var OrderId=rowData.HIDDEN;
				if ((selRowIndex!=="")||(OrderId.indexOf("||")<0)){
					return false;
				}
				var TOeoriOeori=rowData.HIDDEN2;
				var GroupSign=rowData.GroupSign;
				var OrdList=PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('getData');
				//勾选主医嘱
				if ((TOeoriOeori=="")&&(GroupSign!="")){
					for (var idx=rowIndex+1;idx<OrdList.rows.length;idx++) {						var myTOeoriOeori=OrdList.rows[idx].HIDDEN2;
						if (myTOeoriOeori==OrderId){
							selRowIndex=idx;
							PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('checkRow',idx);
						}
					}
				}else if (TOeoriOeori.indexOf("||")>=0){ //勾选子医嘱 存在空行的情况
					var MasterrowIndex=PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('getRowIndex',HIDDEN2);
					PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('checkRow',MasterrowIndex);
				}
				selRowIndex="";
			},
			onUncheck:function(rowIndex, rowData){
				var OrderId=rowData.HIDDEN;
				if ((selRowIndex!=="")||(OrderId.indexOf("||")<0)) return false;
				var OrderId=rowData.HIDDEN;
				var TOeoriOeori=rowData.HIDDEN2;
				var GroupSign=rowData.GroupSign;
				var OrdList=PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('getData');
				//勾选主医嘱
				if ((TOeoriOeori=="")&&(GroupSign!="")){
					for (var idx=rowIndex+1;idx<OrdList.rows.length;idx++) {
						var myTOeoriOeori=OrdList.rows[idx].HIDDEN2;
						if (myTOeoriOeori==OrderId){
							selRowIndex=idx;
							PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('uncheckRow',idx);
						}
					}
				}else if (TOeoriOeori!=""){ //勾选子医嘱
					var MasterrowIndex=PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('getRowIndex',HIDDEN2);
					PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('uncheckRow',MasterrowIndex);
				}
				selRowIndex="";
			},onLoadSuccess:function(data){
				SetPatAllFee()
				/*
				var Length=data.rows.length
				var AllOrderSum=0
				for (var i=0;i<Length;i++){
					var OrderSum=data.rows[i].OrderSum
					AllOrderSum=parseFloat(AllOrderSum)+parseFloat(OrderSum)
					}
				SetPatAllFee(AllOrderSum.toFixed(2))
				*/
			}
		});
		$.extend($.fn.datagrid.methods,{
			keyCtr : function (jq) {
			    return jq.each(function () {
			        var grid = $(this);
			        grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
				    	switch (e.keyCode) {
				            case 38: // up
				                var Selections = grid.datagrid('getSelections');
				                var rows = grid.datagrid('getRows');
				                if (Selections.length>0) {
					                var MaxSelection=null,MinSelection=null;
					                var opts=grid.datagrid('options');
						            $.each(Selections,function(Index,RowData){
						            	if (RowData==null){return true;}
						            	if (RowData[opts.idField]==""){return true;}
						            	if (MaxSelection==null){
						            		MaxSelection=RowData;
						            	}
						            	if (MinSelection==null){
						            		MinSelection=RowData;
						            	}
										var RowIndex=grid.datagrid('getRowIndex',RowData.OrderId);
										var Maxindex=grid.datagrid('getRowIndex',MaxSelection.OrderId);
										var Minindex=grid.datagrid('getRowIndex',MinSelection.OrderId);
										if (Maxindex<RowIndex){
											MaxSelection=RowData;
										}
										if (Minindex>RowIndex){
											MinSelection=RowData;
										}
									});
									if (MinSelection==null){
										var Rows=grid.datagrid('getRows');
										for (var i=Rows.length-1;i>=0;i--) {
											if (Rows[i][opts.idField]!=""){
												MinSelection=Rows[i];
												break;
											}
										}
										var NextIndex=grid.datagrid('getRowIndex', MinSelection);
										var index=NextIndex+1;
									}else{
										var index = grid.datagrid('getRowIndex', MinSelection);
				                    	var NextIndex=index-1;
									}
				                    if (NextIndex<0){
					                	NextIndex=rows.length - 1;
					                }
				                    grid.datagrid('unselectRow',index).datagrid('selectRow', NextIndex);
				                } else {
				                    grid.datagrid('selectRow', rows.length - 1);
				                }
				                break;
				            case 40: // down
				                var Selections = grid.datagrid('getSelections');
				                var rows = grid.datagrid('getRows');
				                if (Selections.length>0) {
				                	var MaxSelection=null,MinSelection=null;
					                var opts=grid.datagrid('options')
						            $.each(Selections,function(Index,RowData){
						            	if (RowData==null){return true;}
						            	if (RowData[opts.idField]==""){return true;}
						            	if (MaxSelection==null){
						            		MaxSelection=RowData;
						            	}
						            	if (MinSelection==null){
						            		MinSelection=RowData;
						            	}
										var RowIndex=grid.datagrid('getRowIndex',RowData.OrderId);
										var Maxindex=grid.datagrid('getRowIndex',MaxSelection.OrderId);
										var Minindex=grid.datagrid('getRowIndex',MinSelection.OrderId);
										if (Maxindex<RowIndex){
											MaxSelection=RowData;
										}
										if (Minindex>RowIndex){
											MinSelection=RowData;
										}
									});
									if (MaxSelection==null){
										grid.datagrid('uncheckAll');
										grid.datagrid('selectRow', 0);
									}else{
					                    var index = grid.datagrid('getRowIndex', MaxSelection);
					                    var NextIndex=index+1;
					                    if (NextIndex>=rows.length){
						                	NextIndex=0;
						                }
						                grid.datagrid('unselectRow',index).datagrid('selectRow', NextIndex);
					                }
				                    
				                } else {
				                    grid.datagrid('selectRow', 0);
				                }
				                break;
				    	}
			    	});
				});
			}
		});
		SurgeryOrdTabDataGrid.datagrid({}).datagrid("keyCtr");
		SurgeryOrdTabDataGrid.datagrid({loadFilter:pagerFilter});
		return SurgeryOrdTabDataGrid;
}
function InitscopeDesc(){
	var scopeDes=[
		  {"id":1,"text":$g("全部")}
		 ,{"id":2,"text":$g("作废")}
		 ,{"id":3,"text":$g("当前"),"selected":true}
		 ,{"id":4,"text":$g("待审核")}
		 ,{"id":5,"text":$g("已停止")}
		 //,{"id":6,"text":"今日有效"}
		 //,{"id":7,"text":"三日有效"}
		]
   var cbox = $HUI.combobox("#scopeDesc", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: scopeDes ,
		onSelect: function (rec) {
			GridParams.scope=rec.id;
			LoadPatOrdDataGrid();
		}
   });
}
function InitlocDesc(){
	//开出科室
	  var cbox = $HUI.combobox("#locDesc", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: [
		  {"id":"1","text":$g("本科室与病区"),"selected":true}
		 ,{"id":"2","text":$g("其它科室")}
		 ,{"id":"3","text":$g("全部")}
		]  ,
		onSelect: function (rec) {
			GridParams.stloc=rec.id;
			LoadPatOrdDataGrid();
		}
   });
}
function InitdoctorList(){
	$.cm({
		ClassName:"web.DHCDocMain",
		MethodName:"GetDoctorList",
		adm:ServerObj.EpisodeID,
		dataType:"text"
	},function(Data){
		var Arr=new Array();
		Data=eval('(' + Data + ')');
		for (var i=0;i<Data.length;i++){
			var id=Data[i][0];
			var text=Data[i][1];
			Arr.push({"id":id,"text":text})
		}
		var cbox = $HUI.combobox("#doctorList", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: Arr,
			onSelect: function (rec) {
				GridParams.doctor=rec.id;
				LoadPatOrdDataGrid();
			}
	   });
	});
}
function LoadPatOrdDataGrid(){
	$.q({
	    ClassName : GridParams.ClassName,
	    QueryName : GridParams.QueryName,
	    papmi : GridParams.papmi,adm : GridParams.adm,
	    doctor : GridParams.doctor,scope : GridParams.scope,
	    stloc : GridParams.stloc,nursebill : GridParams.nursebill,
	    inputOrderDesc : GridParams.inputOrderDesc,
	    Pagerows:PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('uncheckAll').datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
		
	}); 
}
function ShowCancelMulOrdWin(){
   if (!CheckIsCheckOrd()) return false;
   var SelOrdRowStr=GetSelOrdRowStr();
   if (!CheckOrdDealPermission(SelOrdRowStr,"C")) return false;
   var title=$g("撤销(DC)医嘱");
   destroyDialog("OrdDiag");
   var Content=initDiagDivHtml("C");
   var iconCls="icon-w-back";
   createModalDialog("OrdDiag",title, 380, 260,iconCls,$g("撤消(DC)"),Content,"MulOrdDealWithCom('C')");
   InitOECStatusChReason();
   $('#OECStatusChReason').next('span').find('input').focus();
}
function ShowUnUseMulOrdWin(){
   if (!CheckIsCheckOrd()) return false;
   var SelOrdRowStr=GetSelOrdRowStr();
   if (!CheckOrdDealPermission(SelOrdRowStr,"U")) return false;
   var title=$g("作废医嘱");
   destroyDialog("OrdDiag");
   var Content=initDiagDivHtml("U")
   var iconCls="icon-w-back";
   createModalDialog("OrdDiag",title, 380, 260,iconCls,$g("作废"),Content,"MulOrdDealWithCom('U')");
   InitOECStatusChReason();
   $('#OECStatusChReason').next('span').find('input').focus();
}
//医嘱处理公共方法,以type区分不同功能
function MulOrdDealWithCom(type){
   var date="",time="";
   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
   var pinNum="";
   var ReasonId="",Reasoncomment="";
   if ((type=="C")||(type=="U")){
	   ReasonId=$("#OECStatusChReason").combobox("getValue");
	   Reasoncomment=$("#OECStatusChReason").combobox("getText");
	   if (ReasonId==Reasoncomment) ReasonId="";
	   else if (ReasonId!="") Reasoncomment="";
	   if ((ReasonId=="")&&(Reasoncomment=="")){
		   $.messager.alert("提示","请选择或者填写原因!","info",function(){
			   $('#OECStatusChReason').next('span').find('input').focus();
		   });
		   return false;
	   }
	   if ((Reasoncomment!="")&&(Reasoncomment.indexOf("^")>=0)){
			$.messager.alert("提示","撤销原因分隔符^是系统保留符号,请更换成其他符号!",function(){
				$('#OECStatusChReason').next('span').find('input').focus();
			});
			return false;
	   }
   }
   ExpStr=ExpStr+"^"+ReasonId+"^"+Reasoncomment;
   if ($("#winPinNum").length>0){
	   pinNum=$("#winPinNum").val();
	   if (pinNum==""){
		   $.messager.alert("提示","密码不能为空!");
		   $("#winPinNum").focus();
		   return false;
	   }
   }
   var SelOrdRowStr=GetSelOrdRowStr();
   $.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"MulOrdDealWithCom",
	    OrderItemStr:SelOrdRowStr,
	    date:date,
	    time:time,
	    type:type,
	    pinNum:pinNum,
	    ExpStr:ExpStr
	},function(val){
		var alertCode=val.split("^")[0];
		if ((type=="U")&&(alertCode=="-901")){
			alertCode="0"
			$.messager.alert("提示",val.split("^")[1]);
		}
		if (alertCode=="0"){
			PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid("clearSelections");
        	PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid("clearChecked");
			LoadPatOrdDataGrid();
			destroyDialog("OrdDiag");
		}else{
			$.messager.alert("提示",val);
			return false;
		}
	});
}
function CheckOrdDealPermission(SelOrdRowStr,type){
   var rtn=$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"CheckMulOrdDealPermission",
	    OrderItemStr:SelOrdRowStr,
	    date:"",
	    time:"",
	    type:type,
	    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^"
	},false);
   if (rtn!=0){
	   $.messager.alert("提示",rtn);
	   return false;
   }else{
	   return true;
   }
}
function GetSelOrdRowStr(){
   var SelOrdRowStr=""
   var SelOrdRowArr=PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('getChecked');
   for (var i=0;i<SelOrdRowArr.length;i++){
	   if (SelOrdRowArr[i].HIDDEN==""){
		    continue;  
	   }
	   if (SelOrdRowStr=="") SelOrdRowStr=SelOrdRowArr[i].HIDDEN+String.fromCharCode(1)+"";
	   else SelOrdRowStr=SelOrdRowStr+"^"+SelOrdRowArr[i].HIDDEN+String.fromCharCode(1)+"";
   }
   return SelOrdRowStr;
}
function CheckIsCheckOrd(){
   var SelOrdRowArr=PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('getChecked'); //医嘱处理以勾选为准,未勾选代表不处理
   if (SelOrdRowArr.length==0){
	   $.messager.alert("提示","没有勾选医嘱!")
	   return false;
   }
   var Length=0
   $.each(SelOrdRowArr,function(Index,RowData){
		if (RowData.OrderId!=""){
			++Length;
		}
   });
   if (Length==0){
	   $.messager.alert("提示","没有勾选医嘱!")
	   return false;
   }
   return true;
}
function InitOECStatusChReason(){
	 var cbox = $HUI.combobox("#OECStatusChReason", {
		editable: true,
		multiple:false,
		mode:"remote",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:'id',
	  	textField:'text',
	  	data:eval("("+ServerObj.OECStatusChReasonJson+")")
	});
}
function initDiagDivHtml(type){
if((type=="C")||(type=="U")){
	   var html="<div id='DiagWin' style='margin-top: 5px;'>"
		   html +="	<table class='search-table' cellpadding='5' style='padding: 0 63px;;border:none;'>"
		   		html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +=$g("	 请选择原因")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='OECStatusChReason' class='textbox'></input>"
			       	html +="	 </td>"
		        html +="	 </tr>"
		       
		   		html +="	 <tr>"
		       		html +="	 <td class='r-label'>"
		       			html +=$g("	 密码")
		       		html +="	 </td>"
		       		html +="	 <td>"
		       			html +="	 <input type='password' id='winPinNum' class='hisui-validatebox textbox' data-options='required:true' onkeydown='PasswordKeyDownHandle(\"Confirm\",\""+type+"\")'/>"
		       		html +="	 </td>"
		       	html +="	 </tr>"
		       	
		   html +="	</table>"
	   html += "</div>"
   }
   return html;
}
/**
 * 创建一个模态 Dialog
 * @param id divId
 * @param _url Div链接
 * @param _title 标题
 * @param _width 宽度
 * @param _height 高度
 * @param _icon ICON图标
 * @param _btntext 确定按钮text
*/
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
   if(_btntext==""){
	   var buttons=[{
		   text:$g('关闭'),
			iconCls:'icon-w-close',
			handler:function(){
   				destroyDialog(id);
			}
	   }]
   }else{
	   var buttons=[{
			text:_btntext,
			iconCls:_icon,
			handler:function(){
				if(_event!="") eval(_event);
			}
		},{
			text:$g('关闭'),
			iconCls:'icon-w-close',
			handler:function(){
   				destroyDialog(id);
			}
		}]
   }
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;

    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: false,
        content:_content,
        buttons:buttons
    });
}
function destroyDialog(id){
   $("body").remove("#"+id); //移除存在的Dialog
   $("#"+id).dialog('destroy');
}
function ShowOrderDescDetail(that){
	/*var NurseLinkOrderInfo = $.cm({
		ClassName:"web.DHCOEOrdItem",
		MethodName:"GetNurseLinkOrderInfo",
	    OrderRowId:that.id,
		dataType:"text"
	},false);
	if (NurseLinkOrderInfo!=""){
		var content=NurseLinkOrderInfo;
	}else{
		var title="";
		var content=$(that).html(); //保证描述的字体样式在悬浮框也保留
	}*/
	var OrderRowId=that.id;
	var index=PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('getRowIndex',OrderRowId);
	var rows=PageLogicObj.m_SurgeryOrdTabDataGrid.datagrid('getRows');
	var content=rows[index]['PopoverHtml'];
	var contentFlag=content.split("@")[0]; //为0 代表显示的是医嘱列信息 为1代表无论长度都要显示
	var content=content.split("@")[1];
	if ((contentFlag==0)&&($(that).width()<350)) return false;
	var MaxHeight=20;
	var len=content.split("<br/>").length;
	if (len>5) MaxHeight=150,placement="right";
	else MaxHeight='auto',placement="top";
	$(that).webuiPopover({
		title:'',
		content:content,
		trigger:'hover',
		placement:placement,
		style:'inverse',
		height:MaxHeight
		
	});
	$(that).webuiPopover('show');
}
function ordDetailInfoShow(OrdRowID){
	websys_showModal({
		url:"dhc.orderdetailview.csp?ord=" + OrdRowID,
		title:'医嘱明细',
		width:350,height:400,
        iconCls:'icon-w-trigger-box'
	});
}
function pagerFilter(data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		showRefresh:false,
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
			dg.datagrid('scrollTo',0); //滚动到指定的行        
			/*
			刷新当前页的选中行,源码里面做了延迟，要保证堆栈执行顺序，
			这里也要加
			*/
			if (dg[0].id=="tabInPatOrd"){
				setTimeout(function() {
					SetVerifiedOrder(true);
				}, 0);
			}
		},
		onChangePageSize:function(pageSize){
			opts.pageSize = pageSize;
			LoadPatOrdDataGrid();
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	if (opts.pagination){
		if (data.originalRows.length>0) {
			var start = (opts.pageNumber==0?1:opts.pageNumber-1)*parseInt(opts.pageSize);
			if ((start+1)>data.originalRows.length){
				//取现有行数最近的整页起始值
				start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
				opts.pageNumber=(start/opts.pageSize)+1;
			}
			//解决页码显示不正确的问题
			$.extend($.data(pager[0], "pagination").options,{pageNumber:opts.pageNumber});
			
			var end = start + parseInt(opts.pageSize);
			data.rows = (data.originalRows.slice(start, end));
		}
	}
	return data;
	/*	
	var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	//目前发现删除最后一页所有数据之后，页码还是定位到最后一页，但是页码数已经被置到了前一页
	if ((start+1)>data.originalRows.length){
		//取现有行数最近的整页起始值
		start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
		opts.pageNumber=opts.pageNumber-1;
	}
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;*/
}
function PasswordKeyDownHandle(HandleType,EventType){
  if (HandleType=="Confirm"){
     if (window.event.keyCode=="13"){
        MulOrdDealWithCom(EventType);
        return false;
     }
  }
}

function xhrRefresh(Args){
	LoadPatOrdDataGrid();
}

function SetPatAllFee(){
	var AllFee=$.m({
	    ClassName : GridParams.ClassName,
	    MethodName:"GetSosOrderAllFee",
	    papmi : GridParams.papmi,adm : GridParams.adm,
	    doctor : GridParams.doctor,scope : GridParams.scope,
	    stloc : GridParams.stloc,nursebill : GridParams.nursebill,
	    inputOrderDesc : GridParams.inputOrderDesc
	},false);
	$("#PatAllFee").html(AllFee)
}
