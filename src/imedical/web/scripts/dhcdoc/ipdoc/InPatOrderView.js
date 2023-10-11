var opl=ipdoc.lib.ns("ipdoc.patord");
opl.view=(function(){
   function InitInPatOrd(){
	   InittabInPatOrd();
	   InitOrdCopyMenu();
	   InitOrdSaveMenu();
	   InitPageItemEvent();
	   if (ServerObj.PageShowFromWay=="ShowFromEmr"){
		   OrdReSubCatList();
		   $("#MessageMarquee").html(ServerObj.MessageMarquee);
		   //打开医疗待办界面
		   //OpenDocToDoListView();
	   }
	   if (ServerObj.IPDefDisplayMoreContions =='Y') $("#moreBtn").click();
   }
   var InPatOrdDataGridLoadSuccCallBack=$.Callbacks("unique");
	if (ServerObj.DateFormat=="4"){
		//DD/MM/YYYY
        var DATE_FORMAT= new RegExp("(((0[1-9]|[12][0-9]|3[01])/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])/(02))/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29/02/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))");
	}else if(ServerObj.DateFormat=="3"){
		//YYYY-MM-DD
    	var DATE_FORMAT= new RegExp("(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
	}
	var PriorType="S"; //ALL
	if ((ServerObj.PageShowFromWay=="ShowFromOrdEntry")||(ServerObj.PageShowFromWay=="ShowFromEmrList")) {
		PriorType=ServerObj.DefaultOrderPriorType;
	}
	if (ServerObj.PageShowFromWay){
		//初始化病人相关数据
		InitPatOrderViewGlobal(EpisPatInfo);
		
		//初始化住院患者医嘱信息表格
		//var InPatOrdDataGrid;
		//var InPatOrdExecDataGrid;
		var DefaultScopeDesc=GetArrayDefaultData(ServerObj.ViewScopeDescData);
		var DefaultOrderSort=GetArrayDefaultData(ServerObj.ViewOrderSortData);
		var DefaultLocDesc=GetArrayDefaultData(ServerObj.ViewLocDescData);
		var DefaultNurderBill=GetArrayDefaultData(ServerObj.ViewNurderBillData);
		var GridParams={
	        "Arg1":ServerObj.PatientID,"Arg2":ServerObj.EpisodeID,"Arg3":$g("全部")
	        ,"Arg4":DefaultScopeDesc,"Arg5":DefaultLocDesc,"Arg6":DefaultNurderBill,"Arg7":""
	        ,"Arg8":PriorType,"Arg9":"S","Arg10":DefaultOrderSort
	        ,"Arg11":"","Arg12":"","Arg13":"","Arg14":"","Arg15":"","ClassName":"web.DHCDocInPatPortalCommon","QueryName":"FindInPatOrder"
		}
		var OrdExecGridParams={
			"Arg1":"","Arg2":"","Arg3":""
			,"ClassName":"web.DHCDocInPatPortalCommon","QueryName":"FindOrderExecDet"
		}
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
		var index=InPatOrdDataGrid.datagrid('getRowIndex',OrderRowId);
		if (ServerObj.OrderViewScrollView=="1"){
			var rows = InPatOrdDataGrid.datagrid('getData').originalRows;
        }else{
        	var rows = InPatOrdDataGrid.datagrid('getRows');
		}
		var content=rows[index]['PopoverHtml'];
		var contentFlag=content.split("@")[0]; //为0 代表显示的是医嘱列信息 为1代表无论长度都要显示
		var content=content.split("@")[1];
		if ((contentFlag==0)&&($(that).width()<450)) return false;
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
			height:MaxHeight,
			width:"450px",
			
		});
		$(that).webuiPopover('show');
	}
	var selRowIndex="";
	function InittabInPatOrd(){
		/*if ((ServerObj.OrdrightKeyMenuHidden==1)&&(ServerObj.PageShowFromWay!="ShowFromOrdCopy")){
			if(ServerObj.PageShowFromWay=="ShowFromEmrList"){
				var OrdToolBar=[];
			}else{
				var OrdToolBar="";
			}
		}else{*/
			var OrdToolBar=[{
				id:"OrdEnrty_Toolbar",
	            text: '开医嘱',
	            iconCls: 'icon-write-order',
	            handler: function() {
		            if (typeof parent.switchTabByEMR =="function"){
						//parent.switchTabByEMR("dhc_side_oe_oerecord");
						parent.switchTabByEMR($g("医嘱录入"));
					}
		        }
	        },'-',{
		        id:"OrdCopy_Toolbar",
	            text: '复制',
	            iconCls: 'icon-copy',
	            handler: function() {copyOrderHandler(""); }
	        },'-', {
		        id:"OrdStop_Toolbar",
	            text: '停医嘱',
	            iconCls: 'icon-stop-order',
	            handler: function() {ShowStopMulOrdWin();}
	        },{
		        id:"OrdCancel_Toolbar",
	            text: '撤销',
	            iconCls: 'icon-cancel-order',
	            handler: function() {ShowCancelMulOrdWin();}
	        },{
		        id:"OrdUnUse_Toolbar",
	            text: '作废',
	            iconCls: 'icon-abort-order',
	            handler: function() {ShowUnUseMulOrdWin();}
	        },'-', {
		        id:"OrdRefresh_Toolbar",
	            text: '刷新',
	            iconCls: 'icon-reload',
	            handler: function() {LoadPatOrdDataGrid();}
	        },'-', {
		        id:"OrdSave_Toolbar",
	            text: '另存为',
	            iconCls: 'icon-copy'
	        }];
		//}
		/*if (ServerObj.isNurseLogin=="1"){
			OrdToolBar.push({text:'处理医嘱',iconCls: 'icon-abort-order',handler: function() {ShowSeeOrderWin();}});
			OrdToolBar.push({text:'撤销处理',iconCls: 'icon-abort-order',handler: function() {ShowCancelSeeOrderWin();}})
		}*/
		var reg1=/<[^<>]+>/g;
		var reg2=/&nbsp/g;
		/*var OrdColumns=[[ 
					{field:'TItemStatCode',hidden:true,title:''},
		 			{field:'TOeoriOeori',hidden:true,title:''},
		 			{field:'PHFreqDesc1',hidden:true,title:''},
		 			{field:'TPermission',hidden:true,title:''},
		 			{field:'TItemStatCode',hidden:true,title:''},
		 			{field:'InsuNationCode',title:'国家医保编码',align:'center',width:180,auto:false,
		 				formatter:function(value,rec){  
		 				   var btn=""
		 				   if (value!=""){
		                   var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.OrderId + '\')">'+value+'</a>';
					       
		 				   }
		 				   return btn;
                        }
		 			},
		 			{field:'InsuNationName',title:'国家医保名称',align:'center',width:180,auto:false,
		 				formatter:function(value,rec){  
		 				   var btn=""
		 				   if (value!=""){
		                   var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.OrderId + '\')">'+value+'</a>';
					       
		 				   }
		 				   return btn;
                        }
		 			},
		 			{field:'TDoctor',title:'开医嘱人',align:'center',width:80,auto:false},
		 			{field:'TStopDate',title:'停止时间',align:'center',width:140,auto:false,
		 				styler: function(value,row,index){
			 				if ((value!="")&&(value!=" ")){
				 				var stopDate=value.split(" ")[0];
				 				if (CompareDate(stopDate,ServerObj.CurrentDate)){
				 				//if (stopDate>ServerObj.CurrentDate){
					 				return 'background-color:yellow';
					 			}
				 			}
			 			}
		 			},
		 			{field:'TStopDoctor',title:'停止医生',align:'center',width:80,auto:false},
		 			{field:'TStopNurse',title:'停止处理护士',align:'center',width:90,auto:false},
		 			{field:'TItemStatDesc',title:'状态',align:'center',width:80,auto:false,
		 				formatter:function(value,rec){ 
			 				var btn =""; 
							
			 				if (rec.OrderViewFlag=="Y"){
			                	btn = '<a class="editcls" onclick="ipdoc.patord.view.OpenOrderView(\'' + rec.OrderId + '\')">'+value+'</a>';
			 				}else{
				 				btn=value;
				 			}
					        return btn;
                        }
		 			},
		 			{field:'TdeptDesc',title:'开单科室',align:'center',width:120,auto:false},
		 			{field:'TRecDepDesc',title:'接收科室',align:'center',width:120,auto:false},
		 			{field:'Priority',title:'医嘱类型',align:'center',width:80,auto:false},
		 			{field:'OrderType',title:'医嘱子类类型',align:'center',width:60,auto:false},
		 			{field:'TBillUom',title:'计价单位',align:'center',width:80,auto:false},
		 			{field:'GroupSign',title:'组符号',align:'center',width:30,auto:false,
		 			 styler: function(value,row,index){
			 			 return 'color:red;';
		 			 }
		 			},
		 			{field:'OrderId',title:'医嘱ID',align:'center',width:120,auto:false,
		 				formatter:function(value,rec){  
		                   var btn = '<a class="editcls" onclick="ipdoc.patord.view.ordDetailInfoShow(\'' + rec.OrderId + '\')">'+value+'</a>';
					       return btn;
                        }
		 			},
		 			{field:'StopPermission',title:'StopPermission',width:30,auto:false,hidden:true},
		 			{field:'CancelPermission',title:'CancelPermission',width:30,auto:false,hidden:true},
		 			{field:'UnusePermission',title:'UnusePermission',width:30,auto:false,hidden:true},
		 			{field:'TItemStatCode',hidden:true},
		 			{field:'TPriorityCode',hidden:true},
		 			{field:'TStDateHide',hidden:true},
		 			{field:'TPHFreqCode',hidden:true},
		 			{field:'TOEORIAddDate',title:'开医嘱日期',align:'center',width:145,auto:false},
		 			{field:'TOEORISeeInfo',title:'护士处理状态',align:'center',width:145,auto:false},
		 			{field:'AddNotePermission',hidden:true},
		 			{field:'OrderViewFlag',hidden:true},
		 			{field:'ZSQUrl',hidden:true}
		 	]]*/
		var InPatOrdProperty={
			fit : true,
			width:1500,
			border : false,
			striped : false,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : false,
			autoSizeColumn : false,
			rownumbers:true,
			idField:'OrderId',
			//columns :OrdColumns,
			className:"web.DHCDocInPatPortalCommon",
			queryName:"FindInPatOrder",
			toolbar :OrdToolBar,
			onColumnsLoad:function(cm){
				var colWidthObj={
					InsuNationCode:180,
					InsuNationName:180,
					TDoctor:80,
					TStopDate:140,
					TStopDoctor:80,
					TStopNurse:90,
					TdeptDesc:120,
					TRecDepDesc:120,
					Priority:80,
					OrderType:60,
					TBillUom:80,
					GroupSign:30,
					TOeoriRowid:120,
					TOEORIAddDate:145,
					TOEORISeeInfo:145,
					TItemStatDesc:80
				};
				for (var i=cm.length-1;i>=0;i--){
					var field=cm[i]['field'];
					if(["TStDate","TOrderDesc"].indexOf(field)>-1){
						cm.splice(i,1);
						continue;
					}
					if(typeof colWidthObj[field]!='undefined'){
						cm[i].width=colWidthObj[field];
					}
					switch(field){
						case 'InsuNationCode':
							cm[i].formatter = function(value,rec){
								var btn=""
								if (value!=""){
								var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.OrderId + '\')">'+value+'</a>';
								
								}
								return btn;
							}
							break;
						case 'InsuNationName':
							cm[i].formatter = function(value,rec){
								var btn=""
								if (value!=""){
								var btn = '<a class="editcls" onclick="ipdoc.patord.view.InsuNationShow(\'' + rec.OrderId + '\')">'+value+'</a>';
								
								}
								return btn;
							}
							break;
						case 'TStopDate':
							cm[i].styler=function(value,row,index){
								if ((value!="")&&(value!=" ")){
									var stopDate=value.split(" ")[0];
									if (CompareDate(stopDate,ServerObj.CurrentDate)){
									//if (stopDate>ServerObj.CurrentDate){
										return 'background-color:yellow';
									}
								}
							}
							break;
						case 'TItemStatDesc':
							cm[i].formatter=function(value,rec){
								var btn =""; 
								if (rec.OrderViewFlag=="Y"){
									btn = '<a class="editcls" onclick="ipdoc.patord.view.OpenOrderView(\'' + rec.OrderId + '\')">'+value+'</a>';
								}else{
									btn=value;
								}
								return btn;
							}
							break;
						case 'GroupSign':
							cm[i].styler=function(value,row,index){
								return 'color:red;';
							}
							break;
						case 'TOeoriRowid':
							cm[i].formatter = function(value,rec){
								var btn = '<a class="editcls" onclick="ipdoc.patord.view.ordDetailInfoShow(\'' + rec.OrderId + '\')">'+value+'</a>';
								return btn;
							}
							break;
						default:break;
					}
				}
			},
			frozenColumns:[[
				{field:'CheckOrd',title:'选择',checkbox:'true',align:'center',width:70,auto:false},
	 			{field:'TStDate',title:'医嘱开始时间',align:'center',width:140,auto:false},
	 			{field:'TOrderDesc',title:'医嘱',align:'left',width:450,auto:false,
	 				formatter: function(value,row,index){
		 				var inparaOrderDesc=$("#orderDesc").val();
		 				if (inparaOrderDesc!=""){
			 				//var tmpvalue=value.replace(/\&nbsp;/g,"").replace(/\&nbsp/g,"");
			 				var  OriginaName=row["OriginaName"]
			 				OriginaName=OriginaName.replace(inparaOrderDesc,"<font color=red>"+inparaOrderDesc+"</font>");
							var tmpvalue=value;
							tmpvalue = tmpvalue.replace(row["OriginaName"],OriginaName);
							
						}else{
							var tmpvalue=value;
						}
						var ordtitle=tmpvalue //.replace(reg1,'').replace(reg2,' ');
						var PopoverHtml=row['PopoverHtml'];
						if(row.SignFlag=='1'){
							ordtitle='<img src="../skin/default/images/ca_icon_green.png"/>'+ordtitle;
						}
						return '<a class="editcls-TOrderDesc" id= "' + row["OrderId"] + '"onmouseover="ipdoc.patord.view.ShowOrderDescDetail(this)">'+ordtitle+'</a>';
						//return "<span title='" + ordtitle + "' class='hisui-tooltip'>" + value + "</span>";
	 				}
	 			}
			]]
		};
		if (ServerObj.OrderViewScrollView=="1"){
			$.extend(InPatOrdProperty,{
				pagination : false,
				view:scrollview,
				pageSize:(ServerObj.ViewIPDocPatInfoLayOut=="2"?20:30),	//每次初始化的条数
				ScrollView:1	//后台query接收，是否分页
			});
		}else{
			$.extend(InPatOrdProperty,{
				pagination : true,
				pageSize: (ServerObj.ViewIPDocPatInfoLayOut=="2"?10:15),
				pageList : (ServerObj.ViewIPDocPatInfoLayOut=="2"?[10,100,200]:[15,100,200]),
				ScrollView:0
			});
		}
		$.extend(InPatOrdProperty,{
			onClickRow:function(rowIndex, rowData){
                                var OrderId=rowData.OrderId;
				if (OrderId.indexOf("||")<0) return false;
				if (websys_getAppScreenIndex()==0){
					websys_emit("onSelectOrdInDoc",{OrderId:OrderId});
				}
			},
			rowStyler:function(rowIndex, rowData){
	 			if (rowData.ColorFlag=="1"){
		 			return 'color:#788080;';
		 		}else if((rowData.TOeoriOeori=="")&&(rowData.GroupSign!="")&&(rowData.NurseLinkOrderRowId=="")){
			 		return 'background-color:#B8E5AA;';
			 	}
			},
			onClickCell:function(index, field, value){
				if ((ServerObj.PageShowFromWay!="ShowFromOrdEntry")&&(field=="TOrderDesc")) {
					selRowIndex=index;
					if (ServerObj.OrderViewScrollView=="1"){
						var rows = InPatOrdDataGrid.datagrid('getData').originalRows;
		            }else{
			        	var rows = InPatOrdDataGrid.datagrid('getRows');
					}
					var rowData=rows[index];
					var OrderId=rowData.OrderId;
					if (OrderId.indexOf("||")<0) return false;
					//OrdDataGridDbClick(index, rowData);
					LoadOrdExec(rowData,"");
					setTimeout(function() {
						selRowIndex="";
					})
				}
			},
			onDblClickRow:function(rowIndex, rowData){
				OrdDataGridDbClick(rowIndex, rowData);
			},
			onRowContextMenu:function(e, rowIndex, rowData){
				if ((ServerObj.PageShowFromWay!="ShowFromOrdCopy")&&(ServerObj.PageShowFromWay!="ShowFromEmrList")) {
					ShowGridRightMenu(e,rowIndex, rowData,"Ord");
				}
			},
			onCheck:function(rowIndex, rowData){
				var OrderId=rowData.OrderId;
				if ((selRowIndex!=="")||(OrderId.indexOf("||")<0)){
					return false;
				}else if ((ServerObj.PageShowFromWay=="ShowFromOrdEntry")&&(ServerObj.additional=="1")&&(selRowIndex=="")){
					//护士补录模式下，强制走单选模式
					var SelRowList=InPatOrdDataGrid.datagrid('getSelections').slice();
					///这里强制不触发uncheck事件，防止多次调用医嘱录入方法
					var tmp=selRowIndex;
					selRowIndex="1";
					$.each(SelRowList,function(Index,RowData){
						var RowIndex=InPatOrdDataGrid.datagrid('getRowIndex',RowData.OrderId);
						if ((RowIndex!=rowIndex)&&(RowIndex>=0)){
							InPatOrdDataGrid.datagrid('uncheckRow',RowIndex);
						}
					});
					selRowIndex=tmp;
				}
				var TOeoriOeori=rowData.TOeoriOeori;
				var GroupSign=rowData.GroupSign;
				//var OrdList=InPatOrdDataGrid.datagrid('getData');
				if (ServerObj.OrderViewScrollView=="1"){
					var rows = InPatOrdDataGrid.datagrid('getData').originalRows;
	            }else{
		        	var rows = InPatOrdDataGrid.datagrid('getRows');
				}
				var NurseLinkOrderRowId=rowData.NurseLinkOrderRowId;
				//勾选主医嘱
				if ((TOeoriOeori=="")&&(GroupSign!="")&&(NurseLinkOrderRowId=="")){
					for (var idx=rowIndex+1;idx<rows.length;idx++) {
						var myTOeoriOeori=rows[idx].TOeoriOeori;
						var myNurseLinkOrderRowId=rows[idx].NurseLinkOrderRowId;
						var myTStDate=rows[idx].TStDate;
						if ((myTStDate!="")&&(myNurseLinkOrderRowId=="")) myNurseLinkOrderRowId="";
						if ((myTOeoriOeori==OrderId)||(myNurseLinkOrderRowId==OrderId)){
							selRowIndex=idx;
							InPatOrdDataGrid.datagrid('checkRow',idx);
						}
					}
				}else if (TOeoriOeori.indexOf("||")>=0){ //勾选子医嘱 存在空行的情况
					var MasterrowIndex=InPatOrdDataGrid.datagrid('getRowIndex',TOeoriOeori);
					if (MasterrowIndex>=0){
						InPatOrdDataGrid.datagrid('checkRow',MasterrowIndex);
					}
				}else if (NurseLinkOrderRowId.indexOf("||")>=0){ //勾选治疗子医嘱
					var MasterrowIndex=InPatOrdDataGrid.datagrid('getRowIndex',NurseLinkOrderRowId);
					if (MasterrowIndex>=0){
						InPatOrdDataGrid.datagrid('checkRow',MasterrowIndex);
					}
				}
				selRowIndex="";
				/*
				如果是onselectrow触发的oncheck，源码bug会先触发onCheck，然后再
				改变行属性为select状态，这里要使用settimeout，把事件推到堆栈里，保证
				执行顺序
				*/
				setTimeout(function() {
					SetVerifiedOrder(true);
				}, 0);
			},
			onUncheck:function(rowIndex, rowData){
				var OrderId=rowData.OrderId;
				if ((selRowIndex!=="")||(OrderId.indexOf("||")<0)) return false;
				var OrderId=rowData.OrderId;
				var TOeoriOeori=rowData.TOeoriOeori;
				var GroupSign=rowData.GroupSign;
				//var OrdList=InPatOrdDataGrid.datagrid('getData');
				if (ServerObj.OrderViewScrollView=="1"){
					var rows = InPatOrdDataGrid.datagrid('getData').originalRows;
	            }else{
		        	var rows = InPatOrdDataGrid.datagrid('getRows');
				}
				var NurseLinkOrderRowId=rowData.NurseLinkOrderRowId;
				//勾选主医嘱
				if ((TOeoriOeori=="")&&(GroupSign!="")&&(NurseLinkOrderRowId=="")){
					for (var idx=rowIndex+1;idx<rows.length;idx++) {
						var myTOeoriOeori=rows[idx].TOeoriOeori;
						var myNurseLinkOrderRowId=rows[idx].NurseLinkOrderRowId;
						var myTStDate=rows[idx].TStDate;
						if ((myTStDate!="")&&(myNurseLinkOrderRowId=="")) myNurseLinkOrderRowId="";
						if ((myTOeoriOeori==OrderId)||(myNurseLinkOrderRowId==OrderId)){
							selRowIndex=idx;
							InPatOrdDataGrid.datagrid('uncheckRow',idx);
						}
					}
				}else if (TOeoriOeori!=""){ //勾选子医嘱
					var MasterrowIndex=InPatOrdDataGrid.datagrid('getRowIndex',TOeoriOeori);
					if (MasterrowIndex>=0){
						InPatOrdDataGrid.datagrid('uncheckRow',MasterrowIndex);
					}
				}else if (NurseLinkOrderRowId.indexOf("||")>=0){ //勾选治疗子医嘱
					var MasterrowIndex=InPatOrdDataGrid.datagrid('getRowIndex',NurseLinkOrderRowId);
					if (MasterrowIndex>=0){
						InPatOrdDataGrid.datagrid('uncheckRow',MasterrowIndex);
					}
				}
				selRowIndex="";
				SetVerifiedOrder(false);
			},onLoadSuccess:function(data){
				if (ServerObj.PageShowFromWay=="ShowFromOrdEntry"){
					$("#OrdEnrty_Toolbar").hide();
					$("#OrdEnrty_Toolbar").parent().next().hide();
					var startNum=4;
					if (ServerObj.EmConsultItm!=""){
						$('#OrdEnrty_Toolbar,#OrdEnrty_Toolbar,#OrdCopy_Toolbar,#OrdCopyToNorm_Toolbar,#OrdCopyToLong_Toolbar,#OrdCopyToOut_Toolbar').hide();
						$("#OrdEnrty_Toolbar,#OrdCopyToOut_Toolbar").parent().next().hide();
						$("#changeBigBtn").hide(); 
						}
				}else if(ServerObj.PageShowFromWay=="ShowFromOrdCopy"){
					$("#OrdEnrty_Toolbar").hide();
					$("#OrdEnrty_Toolbar").parent().next().hide();
					//$('div.datagrid-toolbar div').eq(1).hide();
					//登录门诊访问住院的医嘱数据
					if ((ServerObj.LogonLocAdmTypeLimit=="N")&&(ServerObj.PAAdmType=="I")){
						$("#OrdCopyToLong_Toolbar,#OrdCopyToOut_Toolbar").hide(); //隐藏复制、复制为长期 复制为出院带药	//#OrdCopy_Toolbar
					}
					$("#OrdStop_Toolbar,#OrdCancel_Toolbar,#OrdUnUse_Toolbar").hide(); //隐藏停止 撤销 作废
					$("#OrdUnUse_Toolbar").parent().next().hide();
					var startNum=5;
					
				}else if(ServerObj.PageShowFromWay=="ShowFromEmrList"){
					$('div.datagrid-toolbar a').hide();
					$('.datagrid-toolbar').css({
						height:"1px",
						padding:"0 2px"
					});
					var startNum=5;
					$('.fixedh2-div').css({
						"border-bottom":"0px dashed #ccc",
						"border-top":"1px dashed #ccc"
					})
					$('.fixedh3-div').css('border-bottom', "0px dashed #ccc");
					InPatOrdDataGrid.datagrid("resize");
				}else if(ServerObj.PageShowFromWay=="ShowFromDocToDo"){
					$('#OrdEnrty_Toolbar,#OrdEnrty_Toolbar,#OrdCopy_Toolbar,#OrdCopyToNorm_Toolbar,#OrdCopyToLong_Toolbar,#OrdCopyToOut_Toolbar').hide();
					$("#OrdEnrty_Toolbar,#OrdCopyToOut_Toolbar,#OrdCopy_Toolbar").parent().next().hide();
					var startNum=6;
				}else if ((ServerObj.OrdrightKeyMenuHidden==1)&&(ServerObj.PageShowFromWay!="ShowFromOrdCopy")){
						$(".datagrid-toolbar").hide();
				}else{
					$(".datagrid-toolbar").show();
					//$("#OrdStop_Toolbar").hide();
				}
				var MenuAdm="";
				var frm = dhcsys_getmenuform();
			    if (frm) {
			    	MenuAdm = frm.EpisodeID.value;
			    }
			    //有可能是检索的其他就诊记录的医嘱进行的复制，按照menu上的就诊进行判断是否展示虚拟长期按钮
				if ((MenuAdm!="")&&(MenuAdm!=ServerObj.EpisodeID)){
					var UserEMVirtualtLong=$.cm({
					    ClassName : "web.DHCDocOrderVirtualLong",
					    MethodName : "GetUserEMVirtualtLong",
					    EpisodeID : MenuAdm
					},false);
					if (UserEMVirtualtLong=="0"){
						$("#OrdCopyToVirLong_Toolbar").hide();
					}
				}else if (ServerObj.UserEMVirtualtLong=="0"){
					$("#OrdCopyToVirLong_Toolbar").hide();
				}
				if (ServerObj.patData.patFlag==0){
					for (var i=startNum;i<parseInt(startNum)+3;i++){
						$('div.datagrid-toolbar a').eq(i).hide();
						$('div.datagrid-toolbar div').eq(i).hide();
					}
				}
				var EpisPatObj=eval("("+EpisPatInfo+")");
				if (EpisPatObj.VisitStatus =="P") {
					$("#OrdCopyToLong_Toolbar,#OrdCopyToOut_Toolbar,#OrdCopyToVirLong_Toolbar").hide();
				}
				if (ServerObj.PageShowFromWay=="ShowFromEmr"){
					InPatOrdDataGrid.datagrid('getPanel').panel('panel').focus();
				}
				InPatOrdDataGridLoadSuccCallBack.fire();
				/*
				///tanjishan 2019-07-08屏蔽，汪工已修正短时间内调用多次xrh方法的bug，不会再出现onloadsuccess不调用的问题
				if (InPatOrdDataGridLoadSuccCallBack.CallBackFunc){
					InPatOrdDataGridLoadSuccCallBack.CallBackFunc();
				}
				*/
			},
			onChangePageSize:function(pageSize){
				//医嘱列表中强制【成组医嘱】一页显示时，为了防止有空行，需要在请求一次数据，把空行去掉
				if ((ServerObj.OrderViewScrollView!="1")&&(ServerObj.GroupOrderOnePage=="Y")){
					LoadPatOrdDataGrid("",pageSize,"OnlyLoadData")
				}
			}
		});
		$.extend(InPatOrdProperty,{loadFilter:DocToolsHUI.lib.pagerFilter});
		InPatOrdDataGrid=$("#tabInPatOrd").datagrid(InPatOrdProperty);
		$.extend($.fn.datagrid.methods,{
			keyCtr : function (jq) {
			    return jq.each(function () {
			        var grid = $(this);
			        grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
				    	switch (e.keyCode) {
				            case 38: // up
				                var Selections = grid.datagrid('getSelections');
				                if (ServerObj.OrderViewScrollView=="1"){
									var rows = grid.datagrid('getData').originalRows;
					            }else{
						        	var rows = grid.datagrid('getRows');
								}
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
					                    ///操作上不再做循环，屏蔽
					                	//NextIndex=rows.length - 1;
					                	//grid.datagrid('scrollTo',NextIndex)
					                	return;
					                }
				                    grid.datagrid('unselectRow',index)
				                    .datagrid('selectRow', NextIndex);
				                	//grid.datagrid('scrollTo',NextIndex);
				                } else {
				                    //grid.datagrid('selectRow', rows.length - 1);
				                    //grid.datagrid('scrollTo',rows.length - 1);
				                    grid.datagrid('selectRow', 0);
				                    grid.datagrid('scrollTo',0);
				                }
				                break;
				            case 40: // down
				                var Selections = grid.datagrid('getSelections');
				                if (ServerObj.OrderViewScrollView=="1"){
									var rows = grid.datagrid('getData').originalRows;
					            }else{
						        	var rows = grid.datagrid('getRows');
								}
				                
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
						                    ///操作上不再做循环，屏蔽
						                	//NextIndex=0;
						                	//grid.datagrid('scrollTo',NextIndex)
						                	return;
						                }
						                grid.datagrid('unselectRow',index)
						                .datagrid('selectRow', NextIndex);
					                	//grid.datagrid('scrollTo',NextIndex);
					                }
				                    
				                } else {
				                    grid.datagrid('selectRow', 0);
				                    grid.datagrid('scrollTo',0);
				                }
				                break;
				    	}
			    	});
				});
			}
		});
		InPatOrdDataGrid.datagrid("keyCtr");
		
   }
   function BClearDateClick(){
		$('#OrdStartSDate').datebox('setValue', '');
		$('#OrdStartEDate').datebox('setValue', '');
		$('#OrdStopSDate').datebox('setValue', '');
		$('#OrdStopEDate').datebox('setValue', '');
   }
	function BFindDateBtnClick(){
		var OrdStartSDate=$HUI.datebox("#OrdStartSDate").getValue();
		var OrdStartEDate=$HUI.datebox("#OrdStartEDate").getValue();
		var OrdStartDateStr=OrdStartSDate+"^"+OrdStartEDate
		var OrdStopSDate=$HUI.datebox("#OrdStopSDate").getValue();
		var OrdStopEDate=$HUI.datebox("#OrdStopEDate").getValue();
		var OrdStopDateStr=OrdStopSDate+"^"+OrdStopEDate
		GridParams.Arg14=OrdStartDateStr
		GridParams.Arg15=OrdStopDateStr
		LoadPatOrdDataGrid();
		$("#Datedialog").dialog("close");
	}
	function DatescopeBtnClick(){
		$("#Datedialog").dialog("open");
		BClearDateClick();
	}
   	function LoadPatOrdDataGrid(SelOrdRowIDNext,pageSize,ActionCode){
   		if (typeof SelOrdRowIDNext =="undefined"){SelOrdRowIDNext="";}
		if (typeof ActionCode =="undefined"){ActionCode="";}
	   	//var myDate = new Date();
    	//var DateTime = myDate.toLocaleString() + '.' + myDate.getMilliseconds();
    	if (ServerObj.OrderViewScrollView=="1"){
	    	var pageSize=99999;
		}else if (typeof pageSize !="undefiend" && pageSize>0){
			//onChangePageSize触发时，Opt中的options尚未赋值，按照传入的值处理
	    }else{
    		var pageSize=InPatOrdDataGrid.datagrid("options").pageSize;
	    }
		if(typeof $('#OrdSearch-div').showMask=='function'){
			$('#OrdSearch-div').showMask();
		}
	    DocToolsHUI.MessageQueue.FireAjax("patord.LoadPatOrdDataGrid");
	   	DocToolsHUI.MessageQueue.Add("patord.LoadPatOrdDataGrid",$.q({
		    ClassName : GridParams.ClassName,
		    QueryName : GridParams.QueryName,
		    papmi : GridParams.Arg1,adm : GridParams.Arg2,
		    doctor : GridParams.Arg3,scope : GridParams.Arg4,
		    stloc : GridParams.Arg5,nursebill : GridParams.Arg6,
		    inputOrderDesc : GridParams.Arg7,PriorType : GridParams.Arg8,
		    CatType : GridParams.Arg9,SortType : GridParams.Arg10,
		    OrderPriorType : GridParams.Arg11,InstrID: GridParams.Arg12,
		    FreqID:GridParams.Arg13,
			OrderStartDate:GridParams.Arg14,
			OrderEndDate:GridParams.Arg15,
		    focusOrdList : ServerObj.DefaultOrdList,
		    Pagerows:pageSize,
		    ScrollView:InPatOrdDataGrid.datagrid("options").ScrollView,
		    rows:99999
		},function(GridData){
			InPatOrdDataGrid.datagrid('unselectAll').datagrid('uncheckAll').datagrid('loadData',GridData);
			if(typeof $('#OrdSearch-div').hideMask=='function'){
				$('#OrdSearch-div').hideMask();
			}
			if (SelOrdRowIDNext!=""){
				SelNextDocOrd(SelOrdRowIDNext);
			}
			if (ServerObj.PageShowFromWay=="ShowFromOrdCopy"){
				if ($("#moreBtn").hasClass('expanded')){
					InPatOrdDataGrid.datagrid("resize");
				}else{
					toggleExecInfo("#moreBtn");
				}
		    }else{
			    if (ServerObj.PageShowFromWay=="ShowFromEmr"){
			    }
			}
		}));

		
	}
	
	function BubbleKeyDown(e){
		$("#tabInPatOrd").datagrid('getPanel').panel('panel').attr('tabindex', 1).trigger(e);
	}
	///补录模式下，和医嘱录入联动
	function SetVerifiedOrder(unCheckFlag){
		var SelRowListRowData=InPatOrdDataGrid.datagrid('getSelections');
		var SelRowList=[];
		var NeedUnCheckRowList=[];
		///删除非本页的数据
		$.each(SelRowListRowData,function(Index,RowData){
			var RowIndex=InPatOrdDataGrid.datagrid('getRowIndex',RowData.OrderId);
			if ((RowIndex>=0)){
				SelRowList.push(RowData);
			}else{
				NeedUnCheckRowList.push(RowIndex);
			}
		});
		if (NeedUnCheckRowList.length>0){
			InPatOrdDataGrid.datagrid("clearChecked");
		}
		if (ServerObj.additional!="1"){return false;}
		var par_win=GetOrdPatWin();
		if (!par_win){return false;}
		if (typeof par_win.SetVerifiedOrder != "function"){return false;}

		///取最后一条的主医嘱
		var ArrLength=SelRowList.length;
		if ((ArrLength==0)||(unCheckFlag==false)){
			par_win.SetVerifiedOrder("");
			return false;
		}
		var RowObj=SelRowList[ArrLength-1];
		if (RowObj.TOeoriOeori!=""){
			var SelOEOrd=RowObj.TOeoriOeori;
		}else{
			var SelOEOrd=RowObj.OrderId;
		}
		$.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"GetLinkOrderStr",
		    OeordId:SelOEOrd
		},function(LinkOrderStr){
			if (par_win)par_win.SetVerifiedOrder(LinkOrderStr);
		});
	}
	
	function SelNextDocOrd(SelOrdRowIDNext){
		//自动选中下一条医嘱
		var par_win=GetOrdPatWin();
		if (!par_win){return false;}
		if (typeof par_win.SetVerifiedOrder != "function"){return false;}
		
		var ListData = InPatOrdDataGrid.datagrid('getData');
		var i = 0;
		var opts = InPatOrdDataGrid.datagrid('options');
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);
		/*尝试下一行*/
		var NextRowIndex="";
		var FindCurrSel=0;
		/*需要翻页的页数*/
		var ScorllPageNum=0;
		for (i=0;i<ListData.originalRows.length;i++){
			//从本条医嘱往后找
			if (SelOrdRowIDNext==ListData.originalRows[i].OrderId){
				FindCurrSel=1
				continue;
			}
			if (FindCurrSel==0){
				continue;
			}
			var OrderId=ListData.originalRows[i].OrderId;
			var TOeoriOeori=ListData.originalRows[i].TOeoriOeori;
			if ((TOeoriOeori=="")&&(OrderId.indexOf("||")>0)){
				NextRowIndex=i;
				break;
			}
		}
		if (NextRowIndex==""){
			/*没找到的情况下,清除选项 par_win.SetVerifiedOrder("");*/
			InPatOrdDataGrid.datagrid('unselectAll');
			par_win.SetVerifiedOrder("");
			return false;
		}
		//InPatOrdDataGrid.datagrid('unselectAll');
		var NeedPageNum=Math.ceil((NextRowIndex+1)/parseInt(opts.pageSize));
		if (opts.pageNumber!=NeedPageNum){
			InPatOrdDataGrid.datagrid('getPager').pagination('select',NeedPageNum);
		}
		NextRowIndex=(NextRowIndex)%parseInt(opts.pageSize);
		InPatOrdDataGrid.datagrid('checkRow',NextRowIndex);
	}
	function GetOrdPatWin(){
		var winName=window.parent.name
		
		if ((winName=="dataframe184")||(winName=="idhc_side_oe_oerecord")||(winName=="idataframe245")||(winName=="EidtOrdXY")){
       		return window.parent;
		}
		return "";
	}
   function OrdDataGridDbClick(rowIndex, rowData,type){
	   //if (ServerObj.isNurseLogin=="1"){
		 if ($("#tabInPatOrdExec").length>0){
	        InPatOrdDataGrid.datagrid("clearChecked");
	        //保证双击或右键时只选中这一行,主要针对成组医嘱
	        selRowIndex=rowIndex;
	        InPatOrdDataGrid.datagrid("checkRow", rowIndex);
	        selRowIndex="";
			if (typeof type == "undefined") {type="";};
			LoadOrdExec(rowData,type);
	    }else{
	        InPatOrdDataGrid.datagrid("clearChecked");
	        InPatOrdDataGrid.datagrid("checkRow", rowIndex);
		}
   }
   function LoadOrdExec(rowData,type){
	if(!$('#Ordlayout_main').layout('panel', 'east').size()) return;
	   if (type===""){
			//双击医嘱,展示执行记录信息
			var collapsed = $('#Ordlayout_main').layout('panel', 'east').panel('options').collapsed;
			if (collapsed == true) {
				$('#Ordlayout_main').layout("expand","east");
			}
		}
		var val=$.m({
		    ClassName:"web.DHCDocMain",
		    MethodName:"getExecDateScope",
		    orderId:rowData.OrderId,
		    execBarExecNum:ServerObj.execBarExecNum
		},false);
		var ExecDateScopeStr=val;
		var StDate=ExecDateScopeStr.split("^")[0];
		var EndDate=ExecDateScopeStr.split("^")[1];
		var OrdInfo=ExecDateScopeStr.split("^")[2];
		var o=$HUI.datebox("#execBarExecStDate");
		o.setValue(StDate);
		var o=$HUI.datebox("#execBarExecEndDate");
		o.setValue(EndDate);
		OrdExecGridParams.Arg1=rowData.OrderId;
		OrdExecGridParams.Arg2=StDate;
		OrdExecGridParams.Arg3=EndDate;
		if (typeof InPatOrdExecDataGrid === 'object'){
			setTimeout(function() {
				LoadInPatOrdExecDataGrid();
			},500)
		}else{
			InitOrdExecGrid();
		}
		$('#Ordlayout_main').layout('panel', 'east').panel('setTitle',OrdInfo);
   }
   function InitOrdExecGrid(){
	  var OrdExecToolBar="";
	   var OrdExecColumns=[[ 
		 			{field:'CheckOrdExec',title:'选择',checkbox:'true'},
		 			{field:'OrderExecId',hidden:true},
		 			{field:'TExStDate',title:'要求执行时间',width:110},
		 			{field:'TRealExecDate',title:'执行时间',width:110},
		 			{field:'TExecState',title:'状态',width:80,
		 				styler: function(value,row,index){
			 				if (row.TExecStateCode){
				 				if( ["未执行","D","C"].indexOf(row.TExecStateCode) > -1 ){
					 				return "background-color: yellow;"
					 			}
			 				}
			 			}
		 			},
		 			{field:'THourExEnTime',title:'小时医嘱结束时间',width:130},
		 			{field:'OrdExecBillQty',title:'计费数量',width:80},
		 			{field:'TExecRes',title:'执行原因',width:100},
		 			{field:'TExecFreeRes',title:'免费原因',width:100,hidden:true},
		 			{field:'TExecUser',title:'处理人',width:80},
		 			{field:'TExecLoc',title:'处理科室',width:80},
		 			{field:'ExecPart',title:'检查部位',width:80},
		 			{field:'TBillState',title:'账单状态',width:80,
		 				formatter:function(value,rec){  
		                   var btn = '<a class="editcls" onclick="ipdoc.patord.view.execFeeDataShow(\'' + rec.OrderExecId + '\')">'+value+'</a>';
					       return btn;
                        }
		 			},
		 			{field:'TExecFreeChargeFlag',title:'免费状态',width:100,hidden:true},
		 			
		 			{field:'TgiveDrugQty',title:'发药数量',width:80},
		 			{field:'TcancelDrugQty',title:'退药数量',hidden:true,width:80},
		 			{field:'Notes',title:'备注',width:100},
		 			{field:'TPBOID',title:'账单号',width:80},
		 			{field:'TApplyCancelStatus',hidden:true},
		 			{field:'TExDateTimes',hidden:true},
		 			{field:'IsCancelArrivedOrd',hidden:true},
		 			{field:'TExecStateCode',hidden:true},
		 			{field:'TPriorityCode',title:'医嘱类型code',hidden:true},
		 			{field:'TBillUom',hidden:true},
		 	]];
		 InPatOrdExecDataGrid=$("#tabInPatOrdExec").datagrid({  
			fit : true,
			width:1500,
			border : false,
			striped : false,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : false,
			rownumbers:true,
			pagination : true,  //
			rownumbers : true,  //
			pageSize: 10,
			pageList : [10,100,200],
			idField:'OrderExecId',
			columns :OrdExecColumns,
			toolbar:OrdExecToolBar,
			onRowContextMenu:function(e, rowIndex, rowData){
				ShowGridRightMenu(e,rowIndex, rowData,"OrdExec");
			}
		});
		LoadInPatOrdExecDataGrid();
   }
   function LoadInPatOrdExecDataGrid(){
	   $.q({
		    ClassName : OrdExecGridParams.ClassName,
		    QueryName : OrdExecGridParams.QueryName,
		    orderId : OrdExecGridParams.Arg1,
		    execStDate:OrdExecGridParams.Arg2,
		    execEndDate: OrdExecGridParams.Arg3,
		    Pagerows:InPatOrdExecDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			InPatOrdExecDataGrid.datagrid("uncheckAll");
			InPatOrdExecDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData); 
		});
   }
   function ShowGridRightMenu(e,rowIndex, rowData,type){
	   e.preventDefault(); //阻止浏览器捕获右键事件
	   $("#RightKeyMenu").empty(); //	清空已有的菜单
	   if (type=="Ord"){
          InPatOrdDataGrid.datagrid("clearChecked");
          selRowIndex=rowIndex; //保证右键时只选中这一行,对成组也是如此
          InPatOrdDataGrid.datagrid("checkRow", rowIndex);
          selRowIndex="";
          if (ServerObj.OrdrightKeyMenuHidden==1) return false;
	      if ((rowData.TPriorityCode=="S")||(rowData.TPriorityCode=="OMST")||(rowData.TPriorityCode=="OMCQZT")){
	         var RightMenu=eval("("+ServerObj.orderRightMenuJson+")");
	      }else{
	         var RightMenu=eval("("+ServerObj.orderSOSRightMenuJson+")");
	      }
	      GetOrdDealPermissionTitle();
	   }else if(type="OrdExec"){
		  InPatOrdExecDataGrid.datagrid("clearSelections"); 
	      InPatOrdExecDataGrid.datagrid("selectRow", rowIndex); 
	      if (ServerObj.ExecrightKeyMenuHidden==1) return false;
	      if ((rowData.TPriorityCode=="S")||(rowData.TPriorityCode=="OMST")||(rowData.TPriorityCode=="OMCQZT")){
		   		var RightMenu=eval("("+ServerObj.execMenuJson+")");
		  }else{
		        var RightMenu=eval("("+ServerObj.execSOSMenuJson+")");
		  }
	   }
	    if ($.isEmptyObject(RightMenu)) return false;
	    var RightMenuArr=RightMenu.menu.items;
	    for (var i=0;i<RightMenuArr.length;i++){
	        var title="";
	        var displayHandler=RightMenuArr[i].displayHandler;
	        if (displayHandler!=""){
	            title=eval(displayHandler)(rowIndex,rowData);
	        }
	        if (RightMenuArr[i].handler=="") continue;
	        $('#RightKeyMenu').menu('appendItem', {
	            id:RightMenuArr[i].id,
				text:RightMenuArr[i].text,
				iconCls: RightMenuArr[i].iconCls, //'icon-ok' 
				onclick: eval(RightMenuArr[i].handler)
			});
			if (title!=""){
				var item = $('#RightKeyMenu').menu('findItem', RightMenuArr[i].text);
				$('#RightKeyMenu').menu('disableItem', item.target);
				$("#"+RightMenuArr[i].id+"").addClass("hisui-tooltip");
				$("#"+RightMenuArr[i].id+"").attr("title",title);
		    }
	    }
	    $('#RightKeyMenu').menu('show', {  
	        left: e.pageX,         //在鼠标点击处显示菜单
	        top: e.pageY
	    });
	   
   }
   function InitPageItemEvent(){
	   $("#Datescope").click(DatescopeBtnClick);	
	   $("#BFindDate").click(BFindDateBtnClick);
	   $("#BClearDate").click(BClearDateClick);
	   BClearDateClick()
	   //开医嘱人
	   var cbox = $HUI.combobox("#doctorList", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: ServerObj.OrdDoctorList,
			onSelect: function (rec) {
				GridParams.Arg3=rec.id;
				LoadPatOrdDataGrid();
			}
	   });
	   if (ServerObj.PageShowFromWay!="ShowFromEmr"){
		   //医嘱分类
		   var OrdReSubCatListJson=eval("("+ServerObj.OrdReSubCatListJson+")");
		   OrdReSubCatListJson.splice(1, 0, {"id":"ALLNotDurg","text":$g("全部非药品")});
		   OrdReSubCatListJson.splice(2, 0, {"id":"ALLLabAndService","text":$g("全部检验检查")});
		   var cbox = $HUI.combobox("#OrderCatTypeId", {
				valueField: 'id',
				textField: 'text',
				editable:false, 
				data: OrdReSubCatListJson,
				onSelect: function (rec) {
					GridParams.Arg9=rec.id;
					LoadPatOrdDataGrid();
				},
				onLoadSuccess:function(){
					var sbox = $HUI.combobox("#OrderCatTypeId");
					sbox.select("ALL");
				}
		   });
		}else if ((ServerObj.PageShowFromWay=="ShowFromEmr")||(ServerObj.PageShowFromWay=="ShowFromOrdCopy")){
			LoadPatOrdDataGrid();
		}
	   var cbox = $HUI.combobox("#scopeDesc", {
			valueField: 'id',
			textField: 'text',
			editable:false, 
			data: ServerObj.ViewScopeDescData,
			onSelect: function (rec) {
				GridParams.Arg4=rec.id;
				LoadPatOrdDataGrid();
			}
	   });
	   //排序
	   var cbox = $HUI.combobox("#OrderSortId", {
			valueField: 'id',
			textField: 'text',
			editable:false, 
			data: ServerObj.ViewOrderSortData,
			onSelect: function (rec) {
				GridParams.Arg10=rec.id;
				LoadPatOrdDataGrid();
			}
	   });
	   //开出科室
	  var cbox = $HUI.combobox("#locDesc", {
			valueField: 'id',
			textField: 'text',
			editable:false, 
			data: ServerObj.ViewLocDescData,
			onSelect: function (rec) {
				GridParams.Arg5=rec.id;
				LoadPatOrdDataGrid();
			}
	   });
	  //医嘱单型
	var cbox = $HUI.combobox("#nursebillDesc", {
			valueField: 'id',
			textField: 'text',
			editable:false, 
			data:ServerObj.ViewNurderBillData,
			onSelect: function (rec) {
				GridParams.Arg6=rec.id;
				LoadPatOrdDataGrid();
			}
	   });
	   //用法
	   var cbox = $HUI.combobox("#InstrDesc", {
			valueField: 'id',
			textField: 'text',
			editable:false, 
			data:ServerObj.ViewInstrJson,
			onSelect: function (rec) {
				GridParams.Arg12=rec.id;
				LoadPatOrdDataGrid();
			}
	   });
	   //频次
	var cbox = $HUI.combobox("#SFreq", {
			valueField: 'id',
			textField: 'text',
			editable:false, 
			data:ServerObj.ViewFreqJson,
			onSelect: function (rec) {
				GridParams.Arg13=rec.id;
				LoadPatOrdDataGrid();
			}
	   });
	   $('#execBarExecStDate').datebox({
		    onChange: function(newValue, oldValue){
			    if (typeof InPatOrdExecDataGrid === 'object'){
				    if ((newValue!=oldValue)&&(DATE_FORMAT.test(newValue))){
					    OrdExecGridParams.Arg2=newValue;
						LoadInPatOrdExecDataGrid();
					}
				}
			    
		    }
	   });
	   $('#execBarExecEndDate').datebox({
		    onChange: function(newValue, oldValue){
			    if (typeof InPatOrdExecDataGrid === 'object'){
				    if ((newValue!=oldValue)&&(DATE_FORMAT.test(newValue))){
						OrdExecGridParams.Arg3=newValue;
						LoadInPatOrdExecDataGrid();
					}
				}
		    }
	   });
	   $('#orderDesc').keydown(function(e){
			if(e.keyCode==13){
				GridParams.Arg7=e.target.value;
				LoadPatOrdDataGrid();
			}
	   });
	   $HUI.radio(".hisui-radio",{
            onChecked:function(e,value){
                GridParams.Arg8=e.target.value;
		    	LoadPatOrdDataGrid();
            }
        });
        $('#Ordlayout_main').layout('panel', 'east').panel({
	      onCollapse: function() {
		        var _width=$('#Ordlayout_main').layout('panel', 'center').panel('options').width;
				$('#Ordlayout_main').layout('panel', 'center').panel('resize',{width:_width});
				//$('#Ordlayout_main').layout('panel', 'center').panel('options').width=_width;
				//$('#Ordlayout_main').layout('resize');
		        InPatOrdDataGrid.datagrid("resize");

				setTimeout(function() {
					if (($("#moreBtn")[0].innerText==$g("隐藏"))&&(ServerObj.PageShowFromWay!="ShowFromEmrList")){
						// var p = $("#OrdSearch")
						// if ((p.height()<=84)&&((ServerObj.PageShowFromWay=="ShowFromEmr"))){
						// 	OrderViewsetHeight(1)
						// }else if ((p.height()<82)&&((ServerObj.PageShowFromWay!="ShowFromEmr"))){
						// 	OrderViewsetHeight(1)
						// }
						OrderViewsetHeight(0);
					}
				},1500)
	        },
	        onExpand: function() {
		        var _eastWidth=$('#Ordlayout_main').layout('panel', 'east').panel('options').width;
				//$('#Ordlayout_main').layout('panel', 'center').panel('resize',{width:_eastWidth});
				$('#Ordlayout_main').layout('panel', 'center').panel('options').width=_eastWidth;
				$('#Ordlayout_main').layout('resize');
		        //病历浏览加载住院医嘱列表，页面左侧两侧不存在空白区域不需要减去20
		        // if (ServerObj.PageShowFromWay!="ShowFromEmrList"){
			    //     width=width-20;
			    // }
		        InPatOrdDataGrid.datagrid("resize");
		        setTimeout(function() {
					if (($("#moreBtn")[0].innerText==$g("隐藏"))&&(ServerObj.PageShowFromWay!="ShowFromEmrList")){
						// var p = $("#OrdSearch")
						// if ((p.height()<=84)&&((ServerObj.PageShowFromWay=="ShowFromEmr"))){
						// 	OrderViewsetHeight(1)
						// }else if ((p.height()<82)&&((ServerObj.PageShowFromWay!="ShowFromEmr"))){
						// 	OrderViewsetHeight(1)
						// }
						OrderViewsetHeight(0);
					}
				},1500)
	        },
	        onResize: function() {

		       var _width=$('#Ordlayout_main').layout('panel', 'center').panel('options').width;
		       if (ServerObj.PageShowFromWay!="ShowFromEmr"){
				    $('#Ordlayout_main').layout('panel', 'center').panel('resize',{width:_width})
		        	InPatOrdDataGrid.datagrid("resize");
		        }else{
			    	//InPatOrdDataGridHeigth=$("#Ordlayout_main").find("div[class='datagrid-body']").height()
					//InPatOrdDataGridHeigth=parseInt(InPatOrdDataGridHeigth)-parseInt(num);
					//$("#Ordlayout_main").find("div[class='datagrid-body']").height(InPatOrdDataGridHeigth)    
			    }
	        }
       });
       $(window).resize(function() {
	       $('#Ordlayout_main').layout('resize',{width:'100%',height:'100%'})
		    InPatOrdDataGrid.datagrid("resize");
	    	setTimeout(function() {
	    		if (($("#moreBtn")[0].innerText==$g("隐藏"))&&(ServerObj.PageShowFromWay!="ShowFromEmrList")){
		    		var p = $("#OrdSearch")
		    		if ((p.height()<=84)&&((ServerObj.PageShowFromWay=="ShowFromEmr"))){
						OrderViewsetHeight(1)
		    		}else if ((p.height()<82)&&((ServerObj.PageShowFromWay!="ShowFromEmr"))){
			    		OrderViewsetHeight(1)
			    		}
				}
				//WQY resize时频闭调用父页面的Changebiggrid 20210512
				/*var par_win=GetOrdPatWin();
				var Changeflag=0
				if (flagbig==1){Changeflag=0}else{Changeflag=1}
				if (par_win)par_win.Changebiggrid(Changeflag);*/
			},1500)
	    });
	   $(document.body).bind("keydown",BodykeydownHandler)
   }
   function BodykeydownHandler(e) {
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
	    if(e.keyCode==13){
		    if ($("#OrdDiag").length>0) {
			    if ((SrcObj.id !="winPinNum")&&(!$(SrcObj).hasClass("validatebox-invalid"))){
				    var _$OrdDiagInput=$("#OrdDiag input");
				    var index = _$OrdDiagInput.index($(SrcObj));
				    var newIndex = index + 1;
				    DiagOrdFocusJump(newIndex);
				}
			}
		    return false;   
	    }
	}
   function DiagOrdFocusJump(Index){
	   var _$OrdDiagInput=$("#OrdDiag input");
	    if(_$OrdDiagInput.length != Index){
		    var isReadOnly=$("#OrdDiag input:eq(" + Index + ")").is('[readonly]')
		    var isHidden=$("#OrdDiag input:eq(" + Index + ")").is(":hidden")
		    if ((!isHidden)&&(!isReadOnly)) {
		    	$("#OrdDiag input:eq(" + Index + ")").focus();
		    }else{
			    Index = Index + 1;
			    DiagOrdFocusJump(Index);
			}
		}
   }
   function OrdReSubCatList(){
	   var OrdReSubCatListJson=ServerObj.OrdReSubCatListJson;
	   OrdReSubCatListJson=OrdReSubCatListJson.slice(0, OrdReSubCatListJson.length-1) + ",{\"id\":\"DocToDoList\",\"text\":\""+$g("医疗待办")+"\"}" + OrdReSubCatListJson.slice(OrdReSubCatListJson.length-1);
	   ServerObj.OrdReSubCatListJson=OrdReSubCatListJson;

	   var ListJson=eval("("+ServerObj.OrdReSubCatListJson+")");
	   for (var i=0;i<ListJson.length;i++){
		   var id=ListJson[i].id;
		   var text=ListJson[i].text;
		   var selected=false
		   if (id=="ALL") selected=true;
		   $('#OrdReSubCatList').tabs('add',{    
			    title:text,    
			    content:'',
			    closable:false,   
			    selected:selected
			})  
	   }
	   $('#OrdReSubCatList').tabs({
		  isBrandTabs:true,
		  onSelect: function(title,index){
			var _$ExecPanel=$('#Ordlayout_main').layout('panel', 'east').parent();
			_$ExecPanel.show();
			var ListJson=eval("("+ServerObj.OrdReSubCatListJson+")");
			var TabsId=ListJson[index-1].id;
			if (TabsId=="DocToDoList"){
				_$ExecPanel.hide();
				if ($("#DocToDoListView").length>0){
					$("#DocToDoListView").show();
					RefreshDocToDoListView();
					return true;
				}
				var TabsHeight=$('#OrdReSubCatList').css("height");
				var OrdViewsHeight=$('#OrdSearch-div').css("height");
				//创建一个容器
				var DIVObj=document.createElement("div");
				$(DIVObj).attr("id","DocToDoListView")
				.css("height", OrdViewsHeight).css("height", "-="+TabsHeight).css("height", "+="+2)
				.css("width","100%")
				.css("top", TabsHeight).css("left", "0px")
				.css("background-color", "#CCC");
				$("#Ordlayout_main").append($(DIVObj).prop("outerHTML"));
				
				//打开医疗待办列表 
				var src="ipdoc.doctodolistview.hui.csp?EpisodeID=" +ServerObj.EpisodeID;
				if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
				$("#DocToDoListView").append("<iframe id='DocToDoListViewFrame' width='100%' height='100%' src='" + src + "' frameborder='0' border='0' marginwidth='0' marginheight='0' scrolling='no'/>");			}else{
				$("#DocToDoListView").hide(); //css("display","none");
				GridParams.Arg9=ListJson[index-1].id;
				if ((ListJson[index-1].text==$g("检查"))||(ListJson[index-1].text==$g("检验"))){
					GridParams.Arg8="OM";
					if ($("#OrderTypeOM").radio('getValue')) {
						LoadPatOrdDataGrid();
					}else{
						$HUI.radio("#OrderTypeOM").setValue(true);
					}
				}else{
		    		LoadPatOrdDataGrid();
		    	}
			}
		  }
	   });
   }
   function copyOrderHandler(priorCode){
	   var SelRowListRowData=InPatOrdDataGrid.datagrid('getSelections');
	   if (SelRowListRowData.length==0){
		   $.messager.alert("提示","请选择需要复制的医嘱!");
		   return false;
	   }
	   var oeoris="";
	   for (var i=0;i<SelRowListRowData.length;i++){
		   if (SelRowListRowData[i].OrderId==""){
			   continue;
		   }
		   if (oeoris=="") oeoris=SelRowListRowData[i].OrderId;
		   else oeoris=oeoris+"^"+SelRowListRowData[i].OrderId;
	   }
	   if (oeoris==""){
		   $.messager.alert("提示","请选择需要复制的医嘱!");
		   return false;
	   }
	   oeoris=oeoris.split("^").sort(function(num1,num2){
	       return parseFloat(num1.split("||")[1])-parseFloat(num2.split("||")[1]);
	   }).join("^");
	   if (typeof parent.switchTabByEMR =="function"){ //dhc_side_oe_oerecord
		   parent.switchTabByEMR($g("医嘱录入"),{oneTimeValueExp:"copyOeoris="+oeoris+"&copyTo="+priorCode});
	   }else{
		   var InOrderPriorRowid="";
		   var VirtualtLongFlag="N"
		   if (priorCode=="S"){
			   InOrderPriorRowid=ServerObj.LongOrderPriorRowid;
		   }else if (priorCode=="NORM"){
			   InOrderPriorRowid=ServerObj.ShortOrderPriorRowid;
		   }else if(priorCode=="OUT"){
			   InOrderPriorRowid=ServerObj.OutOrderPriorRowid;
		   }else if (priorCode=="VirLong"){
			   InOrderPriorRowid=ServerObj.ShortOrderPriorRowid;
			   VirtualtLongFlag="Y";
		   }
		   var ExtStr=VirtualtLongFlag;
		   var CopyOeoriDataArr=new Array();
		   for (var i=0;i<oeoris.split("^").length;i++){
				var Data=tkMakeServerCall("web.DHCDocMain","CreateCopyItem",oeoris.split("^")[i],InOrderPriorRowid,session['LOGON.USERID'],ExtStr);
				if (Data==""){
					continue;
				}
				CopyOeoriDataArr[CopyOeoriDataArr.length]=Data;
		   }
		   if (ServerObj.PageShowFromWay=="ShowFromOrdCopy") {
			   websys_showModal("hide");
			   websys_showModal('options').AddCopyItemToList(CopyOeoriDataArr);
			   websys_showModal("close");
		   }else{
			   parent.AddCopyItemToList(CopyOeoriDataArr);
			   parent.GlobalObj.copyOeorisFlag=false;
		   }
	   }
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
   function GetOnlyOneGroupFlag(SelOrdRowStr){
	   var OnlyOneGroupFlag=1;
	   if (SelOrdRowStr.split("^").length>1) {
		    var ListData = InPatOrdDataGrid.datagrid('getData');
		    var FirstOrdRowid=SelOrdRowStr.split(String.fromCharCode(1))[0];
			for (i=1;i<SelOrdRowStr.split("^").length;i++){
				var OneSelOrdRowStr=SelOrdRowStr.split("^")[i]
				var OrderId=OneSelOrdRowStr.split(String.fromCharCode(1))[0];
				if ((OrderId.indexOf("||")<0)||(OrderId==FirstOrdRowid)) continue;
				var RowIndex=InPatOrdDataGrid.datagrid('getRowIndex',OrderId);
				if (ListData.originalRows) {
					var TOeoriOeori=ListData.originalRows[RowIndex].TOeoriOeori;
				}else{
					var TOeoriOeori=ListData.rows[RowIndex].TOeoriOeori;
				}
				if (((TOeoriOeori!="")&&(TOeoriOeori!=FirstOrdRowid))||(TOeoriOeori=="")&&(OrderId!=FirstOrdRowid)){
					OnlyOneGroupFlag=0;
					break;
				}
			}
	   }
	   return OnlyOneGroupFlag;
   }
   function ShowStopMulOrdWin(){
	   destroyDialog("OrdDiag");
	   if (!CheckIsCheckOrd()) return false;
	   var title=$g("停医嘱");
	   var SelOrdRowStr=GetSelOrdRowStr();
	   if (!CheckOrdDealPermission(SelOrdRowStr,"S")) return false;
	   var SelOrdRowArr=SelOrdRowStr.split("^");
	   var OnlyOneGroupFlag=GetOnlyOneGroupFlag(SelOrdRowStr);
	   if (OnlyOneGroupFlag==1){
		   var ordRowid=SelOrdRowStr.split(String.fromCharCode(1))[0];
		   var val=$.m({
			    ClassName:"web.DHCDocMain",
			    MethodName:"GetPHFreqInfo",
			    oeori:ordRowid
			},false)
			if ((val!="")&&(val.split(",").length>4)){
				val=val.split(",").slice(0,4).join(",")+"...";
			}
			title=title+" "+val;
	   }
	   var Content=initDiagDivHtml("S");
	   var iconCls="icon-w-stop";	//"icon-w-clock";
	   createModalDialog("OrdDiag",title, 380, 315,iconCls,$g("停止"),Content,"MulOrdDealWithCom('S')");
	   InitStopMulOrdWin(SelOrdRowStr,OnlyOneGroupFlag);
	   $("#DiagWin_Info").html($g("已选中")+SelOrdRowArr.length+$g("条医嘱"));
	   $("#winPinNum").focus();
   }
   function ShowCancelMulOrdWin(){
	   if (!CheckIsCheckOrd()) return false;
	   //var FindLongOrd=0;
	   var SelOrdRowStr=GetSelOrdRowStr();
	   if (!CheckOrdDealPermission(SelOrdRowStr,"C")) return false;
	   var SelOrdRowArr=SelOrdRowStr.split("^");
	   /*var SelOrdRowArr=InPatOrdDataGrid.datagrid('getChecked');
	   $.each(SelOrdRowArr,function(Index,RowData){
		   if (RowData["Priority"].indexOf("长期")>=0){
			   FindLongOrd=1;
			   return;
		   }
	   });
	   if (FindLongOrd=="1"){
		   $.messager.alert("提示","勾选的医嘱中有长期医嘱,不能进行【撤销】操作,请重选选择!");
		   return false;
	   }*/
	   var title=$g("撤销(DC)医嘱");
	   destroyDialog("OrdDiag");
	   var Content=initDiagDivHtml("C");
	   var iconCls="icon-w-back";
	   createModalDialog("OrdDiag",title, 380, 195,iconCls,$g("撤销(DC)"),Content,"MulOrdDealWithCom('C')");
	   InitOECStatusChReason();
	   $("#DiagWin_Info").html($g("已选中")+SelOrdRowArr.length+$g("条医嘱"));
	   $('#OECStatusChReason').next('span').find('input').focus();
	   //$("#winPinNum").focus();
   }
   function ShowUnUseMulOrdWin(){
	   if (!CheckIsCheckOrd()) return false;
	   var SelOrdRowStr=GetSelOrdRowStr();
	   if (!CheckOrdDealPermission(SelOrdRowStr,"U")) return false;
	   var SelOrdRowArr=SelOrdRowStr.split("^");
	   var title=$g("作废医嘱");
	   destroyDialog("OrdDiag");
	   var Content=initDiagDivHtml("U")
	   var iconCls="icon-w-edit";
	   createModalDialog("OrdDiag",title, 380, 195,iconCls,$g("作废"),Content,"MulOrdDealWithCom('U')");
	   InitOECStatusChReason();
	   $("#DiagWin_Info").html($g("已选中")+SelOrdRowArr.length+$g("条医嘱"));
	   $('#OECStatusChReason').next('span').find('input').focus();
	   //$("#winPinNum").focus();
   }
   //处理医嘱
   function ShowSeeOrderWin(){
	   if (!CheckIsCheckOrd()) return false;
	   var title=$g("处理医嘱");
	   destroyDialog("OrdDiag");
	   var Content=initDiagDivHtml("NurSeeOrd")
	   var iconCls="icon-w-edit";
	   createModalDialog("OrdDiag",title, 380, 255,iconCls,$g("确认"),Content,"MulOrdDealWithCom('NurSeeOrd')");
	   //类型
	   var cbox = $HUI.combobox("#SeeOrdType", {
		    editable: false,
			valueField: 'id',
			textField: 'text',
			editable:false, 
			data: [
			  {"id":"A","text":"接受","selected":true}
			 ,{"id":"R","text":"拒绝"}
			 ,{"id":"F","text":"完成"}
			]
	   });
	   InitSeeOrdOther();
   }
   function InitSeeOrdOther(){
	   var o=$HUI.datebox('#SeeOrdDate');
	   o.setValue(ServerObj.CurrentDate);
	   /*var cbox = $HUI.combobox("#SeeOrdTime", {
			valueField: 'id',
			textField: 'text',
			data: [
			  {"id":"01:00:00","text":"01:00:00"},{"id":"02:00:00","text":"02:00:00"},{"id":"03:00:00","text":"03:00:00"}
			 ,{"id":"04:00:00","text":"04:00:00"},{"id":"05:00:00","text":"05:00:00"},{"id":"06:00:00","text":"06:00:00"}
			 ,{"id":"07:00:00","text":"07:00:00"},{"id":"08:00:00","text":"08:00:00"},{"id":"09:00:00","text":"09:00:00"}
			 ,{"id":"10:00:00","text":"10:00:00"},{"id":"11:00:00","text":"11:00:00"},{"id":"12:00:00","text":"12:00:00"}
			]
		});
	   cbox.setValue(GetCurTime());*/
	   $("#SeeOrdTime").timespinner('setValue',GetCurTime());
	   $("#SeeOrdNotes").focus();
   }
   //撤销处理
   function ShowCancelSeeOrderWin(){
	   if (!CheckIsCheckOrd()) return false;
	   MulOrdDealWithCom('NurCancelSeeOrd');
   }
   //医嘱处理公共方法,以type区分不同功能
   function MulOrdDealWithCom(type){
	   /*
	   type入参说明
	   ---处理医嘱
	   S:停止
	   C:撤销医嘱
	   U:作废医嘱
	   NurSeeOrd:医嘱处理
	   NurCancelSeeOrd:撤销医嘱处理
	   Addexec:增加执行医嘱
	   CancelPreStopOrd:撤销预停
	   ---处理执行记录
	   NurR:执行
	   NurS:停止执行
	   NurC:撤消执行
	   NurUpdateEndTime:修改小时医嘱结束时间
	   NurA:增加备注
	   */
	   var date="",time="";
	   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
	   var pinNum="";
	   if (type=="S"){
		   var date = $('#winStopOrderDate').datebox('getValue');
		   if (date==""){
			   $.messager.alert("提示","停止日期不能为空!","info",function(){
				   $('#winStopOrderDate').next('span').find('input').focus();
			   });
			   return false;
		   }
		   if(!DATE_FORMAT.test(date)){
			   $.messager.alert("提示","停止日期格式不正确!","info",function(){
				   $('#winStopOrderDate').next('span').find('input').focus();
			   });
			   return false;
		   }
		   if ($("#isExpStopOrderCB").checkbox('getValue')) {
			   if (ServerObj.DateFormat=="4"){
				    var tmpdate=date.split("/")[2]+"-"+date.split("/")[1]+"-"+date.split("/")[0]
				    var tmpdate = new Date(tmpdate.replace("-", "/").replace("-", "/"));
				}else{
					var tmpdate = new Date(date.replace("-", "/").replace("-", "/"));
				}
				var CurDate=new Date();
				var end=new Date(CurDate.getFullYear()+"/"+(CurDate.getMonth()+1)+'/'+ CurDate.getDate());
				if(tmpdate <= end){
					$.messager.alert('提示',"预停时停止日期应大于当天："+myformatter(end)+"！","info",function(){
					     $('#winStopOrderDate').next('span').find('input').focus();
					 });
					 return false;
				}
		   }
		   var time=$('#winStopOrderTime').timespinner('getValue'); //$('#winStopOrderTime').combobox('getText');
		   if (time==""){
			   $.messager.alert("提示","停止时间不能为空!","info",function(){
				   $('#winStopOrderTime').focus();
			   });
			   return false;
		   }
		   if (!IsValidTime(time)){
			   $.messager.alert("提示","停止时间格式不正确! 时:分:秒,如11:05:01","info",function(){
				   $('#winStopOrderTime').focus();
			   });
			   return false;
		   }
	   }else if(type=="Addexec"){
		   var date = $('#winRunOrderDate').datebox('getValue');
		   if (date==""){
			   $.messager.alert("提示","要求执行日期不能为空!");
			   $('#winRunOrderDate').next('span').find('input').focus();
			   return false;
		   }
		   if(!DATE_FORMAT.test(date)){
			   $.messager.alert("提示","要求执行日期格式不正确!");
			   return false;
		   }
		   var time=$('#winRunOrderTime').combobox('getText');
		   if (time==""){
			   $.messager.alert("提示","要求执行时间不能为空!","info",function(){
				   $('#winRunOrderTime').focus();
			   });
			   return false;
		   }
		   if (!IsValidTime(time)){
			   $.messager.$.messager.alert("提示","要求执行时间格式不正确! 时:分:秒,如11:05:01","info",function(){
				   $('#winRunOrderTime').focus();
			   });
			   return false;
		   }
	   }else if (type=="A"){
	       return AddOrderNotes();  
	   }else if (type=="NurR"){
	       return MulOrdExecDealWithCom('R');  
	   }else if (type=="NurS"){
	       return MulOrdExecDealWithCom('D');  
	   }else if (type=="NurC"){
	       return MulOrdExecDealWithCom('C');  
	   }else if (type=="NurUpdateEndTime"){
	       return NurUpdateHourOrdExecEndTime();  
	   }else if (type=="NurA"){
	       return NurAddOrderNotes();  
	   }
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
	   /*if ((type=="S")||(type=="C")||(type=="U")){
			if (ExeCASigin("")==false){
				return false;
			} 
	   }*/
	   ExpStr=ExpStr+"^"+ReasonId+"^"+Reasoncomment;
	   //if (type!="Addexec"){
	   if ($("#winPinNum").length>0){
		   pinNum=$("#winPinNum").val();
		   if (pinNum==""){
			   $.messager.alert("提示","密码不能为空!","info",function(){
				   $("#winPinNum").focus();
			   });
			   return false;
		   }
	   }
	   if ((type=="NurSeeOrd")){
		   var SeeOrdType=$("#SeeOrdType").combobox('getValue');
		   var SeeOrdDate=$('#SeeOrdDate').datebox('getValue');
		   if (SeeOrdDate==""){
			   $.messager.alert("提示","日期不能为空!","info",function(){
				   $('#SeeOrdDate').next('span').find('input').focus();
			   });
			   return false;
		   }
		   if(!DATE_FORMAT.test(SeeOrdDate)){
			   $.messager.alert("提示","日期格式不正确!");
			   return false;
		   }
		   var SeeOrdTime=$('#SeeOrdTime').timespinner('getValue');//$('#SeeOrdTime').combobox('getText');
		   if (SeeOrdTime==""){
			   $.messager.alert("提示","时间不能为空!");
			   $('#SeeOrdTime').next('span').find('input').focus();
			   return false;
		   }
		   if (!IsValidTime(SeeOrdTime)){
			   $.messager.alert("提示","时间格式不正确! 时:分:秒,如11:05:01");
			   return false;
		   }
		   var SeeOrdNotes=$("#SeeOrdNotes").val();
		   if ((SeeOrdNotes!="")&&(SeeOrdNotes.indexOf("^")>=0)){
				$.messager.alert("提示","备注分隔符^是系统保留符号,请更换成其他符号!",function(){
					$('#SeeOrdNotes').next('span').find('input').focus();
				});
				return false;
		   }
		   ExpStr=ExpStr+"^"+SeeOrdType+"^"+SeeOrdDate+"^"+SeeOrdTime+"^"+SeeOrdNotes;
	   }
	   //CancelPreStopOrd
	   var UpdateObj={}
		new Promise(function(resolve,rejected){
		   	//电子签名
		   	var callType=""
		   	if (type=="S"){
			   	callType="OrderStop"
			}else if (type=="C"){
				 callType="OrderCancel"  	
			}else if (type=="U"){
				 callType="OrderUnUse"  	
			}
			CASignObj.CASignLogin(resolve,callType,false)
		}).then(function(CAObj){
			return new Promise(function(resolve,rejected){
		    	if (CAObj == false) {
		    		return websys_cancel();
		    	} else{
		    	$.extend(UpdateObj, CAObj);
		    	resolve(true);
		    	}
			})
		}).then(function(){
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
			var DischargeOEORI="";
			var alertCode=val.split("^")[0];
			if ((type=="U")&&(alertCode=="-100050")){ //-901
				$.messager.alert("提示",val.split("^")[1]);
				val="0";
				DischargeOEORI=val.split("^")[2];
			}
			if (alertCode=="0"){
				if ((type=="S")||(type=="C")||(type=="U")){             //2018-9-4 fxn ca签名
					var CASignOrdStr="";
				    var TempIDs=SelOrdRowStr.split("^");
					var IDsLen=TempIDs.length;
					for (var k=0;k<IDsLen;k++) {
						var TempNewOrdDR=TempIDs[k].split(String.fromCharCode(1));
						if (TempNewOrdDR.length <=0) continue;
						var newOrdIdDR=TempNewOrdDR[0];
						if (newOrdIdDR.indexOf("!")>0){
							newOrdIdDR=newOrdIdDR.split("!")[0];
						}
						if(CASignOrdStr=="")CASignOrdStr=newOrdIdDR;
						else CASignOrdStr=CASignOrdStr+"^"+newOrdIdDR;			
					}
					if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, CASignOrdStr, "S");
					if(CDSSObj) CDSSObj.SynOrder(ServerObj.EpisodeID,CASignOrdStr);
				}
				if (ServerObj.PageShowFromWay){
					InPatOrdDataGrid.datagrid("clearSelections");
	            	InPatOrdDataGrid.datagrid("clearChecked");
					LoadPatOrdDataGrid();
					SetVerifiedOrder(false);
				}else{
					InPatOrdDataGrid.datagrid('reload');
				}
				destroyDialog("OrdDiag");
				if ((ipdoc.pattreatinfo)&&((type=="S")||(type=="C")||(type=="U"))){
					ipdoc.pattreatinfo.view.ReLoadPatAdmInfoJson();
				}
				if ((ServerObj.PageShowFromWay=="ShowFromOrdEntry")&&((type=="C")||(type=="U"))) {
					if (DischargeOEORI=="") DischargeOEORI=val.split("^")[1];
					if (DischargeOEORI!="") {
						var par_win=GetOrdPatWin();
						if (par_win) {
							var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatOrderViewGlobal", ServerObj.EpisodeID);
							par_win.InitPatOrderViewGlobal(EpisPatInfo);
						}
					}
				}
			}else{
				$.messager.alert("提示",alertCode,"info",function(){
					if (alertCode.indexOf("成功")>=0) {
						destroyDialog("OrdDiag");
					}
				});
				return false;
			}
		});
		})
   }
   function IsValidDate(DateStr){ 
      //todo 验证日期有效性
   	  return true;
   }
   function IsValidTime(time){
	   if (time.split(":").length==3){
		   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/;
	   }else if(time.split(":").length==2){
		   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;  
	   }else{
		   return false;
	   }
	   if(!TIME_FORMAT.test(time)) return false;
	   return true;
   }
   function AddOrderNotes(){
	   var OrderNotes=$("#OrderNotes").val();
	   if (OrderNotes==""){
		   $.messager.alert("提示","备注为空,请填写备注!");
		   return false;
	   }
	   var rowrecord = InPatOrdDataGrid.datagrid('getSelected');
	   $.m({
		    ClassName:"web.DHCDocMain",
		    MethodName:"InsertOEORIdepProcNotes",
		    OEORI:rowrecord.OrderId,
		    OrderNotes:OrderNotes
		},function(val){
			if (val=="0"){
				LoadPatOrdDataGrid();
		   		destroyDialog("OrdDiag");
			}
		});
   }
   function destroyDialog(id){
	   $("body").remove("#"+id); //移除存在的Dialog
	   $("#"+id).dialog('destroy');
   }
   function CheckIsCheckOrd(){
	   var SelOrdRowArr=InPatOrdDataGrid.datagrid('getChecked'); //医嘱处理以勾选为准,未勾选代表不处理
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
   function GetSelOrdRowStr(){
	   var SelOrdRowStr=""
	   var SelOrdRowArr=InPatOrdDataGrid.datagrid('getChecked');
	   for (var i=0;i<SelOrdRowArr.length;i++){
		   if (SelOrdRowArr[i].OrderId==""){
			    continue;  
		   }
		   if (SelOrdRowStr=="") SelOrdRowStr=SelOrdRowArr[i].OrderId+String.fromCharCode(1)+SelOrdRowArr[i].TStDateHide;
		   else SelOrdRowStr=SelOrdRowStr+"^"+SelOrdRowArr[i].OrderId+String.fromCharCode(1)+SelOrdRowArr[i].TStDateHide
	   }
	   return SelOrdRowStr;
   }
   function InitStopMulOrdWin(SelOrdRowStr,OnlyOneGroupFlag){
	   var FirstOrdRowid=SelOrdRowStr.split("^")[0].split(String.fromCharCode(1))[0];
	   $('#winStopOrderDate').datebox({
		    onHidePanel:function(){
			    var date=$('#winStopOrderDate').datebox("getValue")
			    LoadwinStopOrderTimes(FirstOrdRowid,date);
			}
		});
	   var o=$HUI.datebox('#winStopOrderDate');
	   o.setValue(ServerObj.CurrentDate);
	   if (OnlyOneGroupFlag==0){
		   $('#winStopOrderTimes').parent().parent().hide();
	   }else{
		   $('#winStopOrderTimes').parent().parent().show();
	   }
	   
	   LoadwinStopOrderTimes(FirstOrdRowid,ServerObj.CurrentDate);
	   $("#winStopOrderTime").timespinner('setValue',GetCurTime());
	   $HUI.checkbox("#isExpStopOrderCB",{
		   onChecked:function(event,value){
			    $("#winStopOrderDate").datebox({ disabled:false,minDate:ServerObj.NextDate});
				$("#winStopOrderDate").datebox("setValue",ServerObj.NextDate);
				//$("#winStopOrderTimes").combobox({ disabled:false});
				LoadwinStopOrderTimes(FirstOrdRowid,ServerObj.NextDate);
				$("#winStopOrderTime").timespinner('setValue',GetCurTime());
				$("#winStopOrderDate").next('span').find('input').focus();
	   		},
	   		onUnchecked:function(){
			    $("#winStopOrderDate").datebox({ disabled:true,minDate:null})
			   	$("#winStopOrderDate").datebox("setValue",ServerObj.CurrentDate);
			   	//$("#winStopOrderTimes").combobox({ disabled:true})
			   	LoadwinStopOrderTimes(FirstOrdRowid,ServerObj.CurrentDate);
			   	$("#winStopOrderTime").timespinner('setValue',GetCurTime());
			   	$("#winStopOrderTime").focus();
	   		}
	   });
   }
   function LoadwinStopOrderTimes(oeori,date){
	   $("#winStopOrderTimes").combobox({
			url:$URL+"?ClassName=web.DHCDocInPatPortalCommon&QueryName=GetPHFreqInfoList&rows=99999",
	        mode:'remote',
	        method:"Get",
			editable: false,
			multiple:false,
			selectOnNavigation:true,
		  	valueField:'id',
		  	textField:'text',
			onSelect: function (record) {
				var sbox = $HUI.timespinner("#winStopOrderTime");
				//sbox.setValue(record.id+":10");
				sbox.setValue(record.seltext);
				$("#winPinNum").focus();
		    },
		    onBeforeLoad:function(param){
		        param.oeori=oeori;
		        param.date=date;
		    },loadFilter:function(data){
			    return data['rows'];
			}
		});
   }
   function GetCurTime(){
	   function p(s) {
		   return s < 10 ? '0' + s: s;
	   }
	   var myDate = new Date();
	   var h=myDate.getHours();       //获取当前小时数(0-23)
	   var m=myDate.getMinutes();     //获取当前分钟数(0-59)
	   var s=myDate.getSeconds();  
	   var nowTime=p(h)+':'+p(m)+":"+p(s);
	   return nowTime;
   }
   function DiagDivKeyDownHandle(HandleType,EventType){
      if (HandleType=="Confirm"){
         if (window.event.keyCode=="13"){
	        MulOrdDealWithCom(EventType);
	        return false;
         }
      }
   }
   function StopTimeFocusJump(index){
	   if (window.event.keyCode=="13"){
	        DiagOrdFocusJump(index);
	        return false;
         }
   }
	function initDiagDivHtml(type){
		var obj={"Type":type};
		if(typeof websys_getMWToken=='function') obj["MWToken"]=websys_getMWToken();
		var html="";
	   	$.ajax("dhcdoc.orderinterface.csp",{
			type : "POST",
			dataType:"html",
			async: false, 
			data:obj,
			success:function(data) {
				html=data.replace(/\r\n/g,"");
			},
			"error" : function(XMLHttpRequest, textStatus, errorThrown) {
				console.log(textStatus);
			}
		})
		return html
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
		   var buttons=[];
	   }else{
		   var buttons=[{
				text:_btntext,
				iconCls:_icon,
				handler:function(){
					if(_event!="") eval(_event);
				}
			}]
	   }
	   //如果去掉关闭按钮，当用户点击窗体右上角X关闭时，窗体无法回调界面销毁事件，需要基础平台协助处理
	   buttons.push({
		   text:$g('关闭'),
			iconCls:_icon==""?"":'icon-w-close',
			handler:function(){
   				destroyDialog(id);
			}
	   });
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
	    //翻译
	    var $nodes=$("#"+id).find("td.r-label")
		for (var i=0; i< $nodes.length; i++){
			var _$label = $($("#"+id).find("td.r-label")[i]);
			if (_$label.length > 0){
				domName = _$label[0].innerHTML;
				_$label[0].innerHTML=$g(domName);
			}
			}
   }
   function myformatter(date){
		var y = date.getFullYear();
		var m = date.getMonth()+1;
		var d = date.getDate();
		if (ServerObj.DateFormat==3){
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		}else if(ServerObj.DateFormat==4){
			return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
		}
	}
	function myparser(s){
		if (!s) return new Date();
		if (ServerObj.DateFormat==3){
			var ss = s.split('-');
			var y = parseInt(ss[0],10);
			var m = parseInt(ss[1],10);
			var d = parseInt(ss[2],10);
			if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
				return new Date(y,m-1,d);
			} else {
				return new Date();
			}
		}else if(ServerObj.DateFormat==4){
			var ss = s.split('/');
			var y = parseInt(ss[2],10);
			var m = parseInt(ss[1],10);
			var d = parseInt(ss[0],10);
			if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
				return new Date(y,m-1,d);
			} else {
				return new Date();
			}
		}
			
	}
	function stopOrderHandler(){
		ShowStopMulOrdWin();
	}
	function stopOrderShowHandler(rowIndex,record){
		var index=$.hisui.indexOfArray(OrdRightTitleJson,"type","S")
		var title=OrdRightTitleJson[index].title;
		if (title!="") title=$g(title);
		/*var title="";
		if (record.OrderId==""){
			title=$g("请选中一条医嘱!");
		}else if (record.TItemStatCode=="D"){
			title=$g("医嘱已停止,不能停止!");
		}else if (record.TItemStatCode=="E"){
			title=$g("医嘱已执行过,不能停止!");
		}else if (record.StopPermission=="0"){
			title=$g("没有权限停止!");
		}*/
		return title;
	}
	function cancelOrderShowHandler(rowIndex,record){
		var index=$.hisui.indexOfArray(OrdRightTitleJson,"type","C")
		var title=OrdRightTitleJson[index].title;
		if (title!="") title=$g(title);
		/*var title="";
		if (record.OrderId==""){
			title=$g("请选中一条医嘱!");
		}else if (record.TItemStatCode=="D"){
			title=$g("医嘱已停止,不能撤消!");
		}else if (record.TItemStatCode=="E"){
			title=$g("医嘱已执行过,不能撤消!");
		}else if (record.TItemStatCode=="C"){
			title=$g("医嘱已撤销,不能撤消!");
		}else if (record.TItemStatCode=="U"){
			title=$g("医嘱已作废,不能撤消!");
		}else if(record.CancelPermission == "0"){
			title = $g("权限不够 或 医嘱已被执行!");
		}else if ((record.TPriorityCode=="S")||(record.TPriorityCode=="OMST")||(record.TPriorityCode=="OMCQZT")){
			title = $g("长期医嘱不允许撤销!");
		}*/
		return title;
	}
	function cancelOrderHandler(){
		ShowCancelMulOrdWin();
	}
	function abortOrderHandler(){
		ShowUnUseMulOrdWin();
	}
	function abortOrderShowHandler(rowIndex,record){
		var index=$.hisui.indexOfArray(OrdRightTitleJson,"type","U")
		var title=OrdRightTitleJson[index].title;
		if (title!="") title=$g(title);
		/*var title="";
		if (record.OrderId==""){
			title=$g("请选中一条医嘱!");
		}else if (record.TItemStatCode=="D"){
			title=$g("医嘱已停止,不能作废!");
		}else if (record.TItemStatCode=="E"){
			title=$g("医嘱已执行过,不能作废!");
		}else if (record.TItemStatCode=="U"){
			title=$g("医嘱已作废,不能再作废!");
		}else if(record.UnusePermission == "0"){
			title = $g("权限不够 或 医嘱已被执行!");
		}*/
		return title;
	}
	function addOrderNotesHandler(){
	    destroyDialog("OrdDiag");
	    var Content=initDiagDivHtml("A");
	    var iconCls="icon-w-add";
	    createModalDialog("OrdDiag","增加备注", 380, 250,iconCls,"增加备注",Content,"MulOrdDealWithCom('A')");
	    //获取医嘱已有备注
	    var rowrecord = InPatOrdDataGrid.datagrid('getSelected');
	    $.m({
			    ClassName:"web.DHCDocMain",
			    MethodName:"GetOEORIdepProcNotes",
			    OEORI:rowrecord.OrderId
			},function(val){
				if (val!="") $("#OrderNotes").val(val);
				$("#OrderNotes").focus();
		});
	}
	function addOrderNotesShowHandler(rowIndex,record){
		var AddNotePermission=$.cm({
		    ClassName : "web.DHCDocMain",
		    MethodName : "CheckAddNoteOrder",
		    OrderItemRowId : record.OrderId,
		    UserRowId : session['LOGON.USERID'],
		    LocID : session['LOGON.CTLOCID'],
		    GroupID : session['LOGON.GROUPID']
		},false);
	    var title="";
		/*if (record.OrderId==""){
			title="请选中一条医嘱!";
		}else if (record.AddNotePermission=="-1"){
			title="医嘱已打印医嘱单!";
		}else if (record.AddNotePermission=="-2"){
			title="医嘱护士已审核!";
		}else if (record.AddNotePermission=="-3"){
			title="患者已进入结算流程!";
		}else if (record.AddNotePermission!="1"){
			title="不允许添加备注";
		}*/
		if (record.OrderId==""){
			title=$g("请选中一条医嘱!");
		}else if (AddNotePermission=="-1"){
			title=$g("医嘱已打印医嘱单!");
		}else if (AddNotePermission=="-2"){
			title=$g("医嘱护士已审核!");
		}else if (AddNotePermission=="-3"){
			title=$g("患者已进入结算流程!");
		}else if (AddNotePermission!="1"){
			title=$g("不允许添加备注");
		}
		return title;
	}
	function consultationHandler(){// dhcconsultpat.csp
		//window.showModalDialog("dhcem.consultmain.csp?PatientID="+ServerObj.PatientID+"&EpisodeID="+ServerObj.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:900px;resizable:yes");	
		websys_showModal({
			url:"dhcem.consultmain.csp?PatientID="+ServerObj.PatientID+"&EpisodeID="+ServerObj.EpisodeID,
			title:'会诊申请',
			width:'95%',height:'80%',
			CallBackFunc:function(CallBackData){
				LoadPatOrdDataGrid();
			}
		})
	}
	function consultationShowHandler(){
		var title="";
		var patDataObj=ServerObj.patData //eval("("+ServerObj.patData+")");
		if (patDataObj.patFlag>0){
			title=$g("病人已")+patDataObj.flagDesc+"!";
		}
		return title;
	}
	function surgeryApplyHandler(){ //dhcclinic.anop.app.csp
		//window.showModalDialog("dhcanoperapplication.csp?opaId=&appType=ward&EpisodeID="+ServerObj.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:1250px;resizable:yes");	
		websys_showModal({
			//url:"dhcanoperapplication.csp?opaId=&appType=ward&EpisodeID="+ServerObj.EpisodeID,
			url:"CIS.AN.OperApplication.New.csp?opsId=&EpisodeID="+ServerObj.EpisodeID,
			title:'手术申请',
			width:'90%',height:'90%',
			CallBackFunc:function(CallBackData){
				LoadPatOrdDataGrid();
			}
		})
	}
	function surgeryApplyShowHandler(){
		var title="";
		var patDataObj=ServerObj.patData //eval("("+ServerObj.patData+")");
		if (patDataObj.patFlag>0){
			title=$g("病人已")+patDataObj.flagDesc+"!";
		}
		return title;
	}
	//输血申请 原版本没有处理,此版本暂不做处理
	function bloodApplyHandler(){}
	function bloodApplyShowHandler(){return "";}
	//增加免费医嘱 原版本没有处理,此版本暂不做处理
	function addBillOrderHandler(){}
	//免费 原版本没有处理,此版本暂不做处理
	function freeExecOrderHandler(){} 
	function freeExecOrderShowHandler(){return "";}
	//取消免费 原版本没有处理,此版本暂不做处理
	function cancelFreeExecOrderHandler(){}
	function cancelFreeExecOrderShowHandler(){return "";}
	//增加费用 原版本没有处理,此版本暂不做处理
	function addFeeExecOrderHandler(){}
	function addFeeExecOrderShowHandler(){return "";}
	
	/**
	Modify 20230207
	药品说明书使用新产品组合理用药，检查检验等将使用基础数据平台
	*/
	function OrderYDTSShowHandler(rowIndex,record){
		var title="";
		if (record.YDTSUrl==""){
			title=$g("没有有效的说明书信息");
		}
		return title;
		
	}
	function OrderYDTSHandler(){
		var record = InPatOrdDataGrid.datagrid('getSelected');
		if (!record){
			return;
		}
		var ItmMastDR = record.ItmMastDR;
		if(ItmMastDR==""){
			$.messager.alert("警告", "无效的医嘱,无法查看说明书","warning");
			return;
		}
		var OrderType = record.OrderType;
		//只有药品才走合理用药
		if((HLYYConfigObj.HLYYInterface==1)&&(OrderType=='R')){
			Common_ControlObj.Interface("YDTS",{
				ARCIMRowid:ItmMastDR
			});
		}else{
			$.messager.alert("提示", "未启用或未维护相应说明书","warning");	
		}
	}
	/**
	Modify 20230207
	旧版知识库，停用
	使用新版说明书
	*/
	function OrderZSQShowHandler(rowIndex,record){
		var title="";
		if (record.ZSQUrl==""){
			title=$g("没有有效的知识库信息");
		}
		return title;
		
	}
	function OrderZSQHandler(){
		var record = InPatOrdDataGrid.datagrid('getSelected');
		if (!record){
			return;
		}
		var ZSQUrl=record.ZSQUrl;
		if (ZSQUrl==""){
			return;
		}
		websys_showModal({
			url:ZSQUrl,
			title:'说明书',
			iconCls:'icon-w-paper',
			//width:screen.availWidth-200,height:screen.availHeight-200
            width:"85%",height:screen.availHeight-200
		});
	}
	function ChangeOrderDoseQtyShowHandler(rowIndex,record){
		var title=""
		if (record.OrderId==""){
			title=$g("请选中一条医嘱!");
		}else if (record.TItemStatCode=="D"){
			title=$g("医嘱已停止,不能修改!");
		}else if (record.TItemStatCode=="E"){
			title=$g("医嘱已执行过,不能修改!");
		}else if (record.StopPermission=="0"){
			title=$g("没有权限修改!");
		}
		if (title!=""){
			return title;
		}
		title=$.cm({
		    ClassName : "web.DHCOEOrdItemDoseQty",
		    MethodName : "ChangeOrderDoseQtyShow",
		    OEORIRowid : record.OrderId,
		    dataType:"text"
		},false);
		return $g(title);
	}
	function ChangeOrderDoseQtyHandler(){
		
		var SelOrdRowStr=GetSelOrdRowStr();
        if(SelOrdRowStr==""){
            $.messager.popover({msg: '请选择需要修改的医嘱',type:'alert'});
            return;
        }
        if(SelOrdRowStr.split("^").length>1){
            $.messager.popover({msg: '只能选择一条医嘱操作',type:'alert'});
            return;
        }
        var OEORIRowid=SelOrdRowStr.split(String.fromCharCode(1))[0];
        var ret=tkMakeServerCall('web.DHCOEOrdItemDoseQty','HasDoseQtyRecord',OEORIRowid);
        if(ret==''){
	        $.messager.popover({msg: '非长期有药医嘱,不能修改单次剂量',type:'alert'});
            //return;
	    }
        var src = "ipdoc.order.doseqtystr.edit.hui.csp?OEORIRowid="+OEORIRowid;
	    //ShowHISUIWindow("修改医嘱单次剂量",src,"icon-edit",900,500);
		websys_showModal({
			url:src,
			iconCls: 'icon-w-edit',
			title:$g('修改不规则医嘱单次剂量'),
			width:900,height:550,
			CallBackFunc:function(rtnValue){
				websys_showModal("close");
				//AddCopyItemToList(rtnValue.split(','));
			}
		})
		/*
		destroyDialog("OrdDiag");
	    var Content=initDiagDivHtml("A");
	    var iconCls="icon-w-add";
	    createModalDialog("OrdDiag","增加备注", 380, 245,iconCls,"增加备注",Content,"MulOrdDealWithCom('A')");
	    //获取医嘱已有备注
	    var rowrecord = InPatOrdDataGrid.datagrid('getSelected');
	    $.m({
			    ClassName:"web.DHCDocMain",
			    MethodName:"GetOEORIdepProcNotes",
			    OEORI:rowrecord.OrderId
			},function(val){
				if (val!="") $("#OrderNotes").val(val);
				$("#OrderNotes").focus();
		});
		*/
	}
	
	
	//prn增加执行医嘱
	function addExecOrderHandler(){
		destroyDialog("OrdDiag");
	    var Content=initDiagDivHtml("AddExec");
	    var iconCls="icon-ok";
	    createModalDialog("OrdDiag","增加执行医嘱", 380, 260,iconCls,"确定",Content,"MulOrdDealWithCom('Addexec')");
	    var o=$HUI.datebox('#winRunOrderDate');
	    o.setValue(ServerObj.CurrentDate);
	    var cbox = $HUI.combobox("#winRunOrderTime", {
			editable: true,
			multiple:false,
			mode:"remote",
			method: "GET",
			selectOnNavigation:true,
		  	valueField:'id',
		  	textField:'text',
		  	data:eval("("+ServerObj.IntervalTimeListJson+")"),
		  	onLoadSuccess:function(){
				var sbox = $HUI.combobox("#winRunOrderTime");
				sbox.setValue("");
			}
		});
	    $('#winRunOrderTime').next('span').find('input').focus();
	}
	function addExecOrderShowHandler(rowIndex,record){
		var title="";
		var orderStatus = record.TItemStatCode;
		var PHFreqCode = record.TPHFreqCode;
		var oeoriOeoriDr= record.TOeoriOeori ;
		if(orderStatus == "D") {
			title = $g("医嘱已停止,不能增加!");
			return title;
		}else if(PHFreqCode.toLocaleUpperCase() != "PRN"){
			title = $g("prn医嘱才能增加!");
			return title ;
		}else if(PHFreqCode.toLocaleUpperCase() == "PRN" && oeoriOeoriDr!=""){
			title = $g("请在主医嘱上增加执行记录!");			
			return title ;				
		}
		return title;
	}
	/*执行记录执行相关方法*/
	function runExecOrderHandler(){
		if (!CheckIsCheckOrdExec()) return false;
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurR");
	    var iconCls="icon-exe-order";
	    createModalDialog("NurOrdDiag","执行", 380, 260,iconCls,"确定",Content,"MulOrdDealWithCom('NurR')");
	    InitRunOrdExecContions();
	    $('#winRunOrderTime').next('span').find('input').focus();
	}
	function InitRunOrdExecContions(){
		$("#winRunOrderDate").datebox("setValue",ServerObj.CurrentDate);
		var cbox = $HUI.combobox("#winRunOrderTime", {
			editable: true,
			multiple:false,
			mode:"remote",
			method: "GET",
			selectOnNavigation:true,
		  	valueField:'id',
		  	textField:'text', 
		  	data:eval("("+tkMakeServerCall("web.DHCDocInPatUICommon","GetIntervalTimeList","Y")+")"),
			onLoadSuccess:function(){
				var sbox = $HUI.combobox("#winRunOrderTime");
				sbox.select(sbox.options().data[0].id);
			}
		  	
		});
	}
	function runExecOrderShowHandler(rowIndex,record){
		var title="";
		if (["3","4","5"].indexOf(ServerObj.patData.patFlag)>-1){
			title=$g("病人已")+patData.flagDesc+"!";
		}
		var execStatus = record.TExecStateCode;
		var orderStatCode = record.TItemStatCode;
		var IsCanExecOrdArrear = record.IsCanExecOrdArrear;
		if(execStatus != "C" && execStatus != $g("未执行")) {
			title = $g("只有未执行与撤销执行的执行记录才能执行!");
		}else if(orderStatCode == "U"){
			title = $g("医嘱已作废!");
			return title;
		}else if(orderStatCode == "P"){
			title = $g("医嘱Pre-Order!");
			return title;
		}else if(orderStatCode == "I"){
			title = $g("医嘱未核实!");
			return title;
		}else if(IsCanExecOrdArrear=="FeeNotEnough"){
			title = $g("费用不足,不能执行!");
			return title;
		}else if("SkinAbnorm"==IsCanExecOrdArrear){
			title = $g("皮试医嘱结果为阳性,不能执行!");
			return title;
		}else if("DrugSubOrder"==IsCanExecOrdArrear){
			title = $g("药品子医嘱不允许执行!");
			return title;
		}else if("NotSeeOrd"==IsCanExecOrdArrear){
			title = $g("医嘱未处理,不能执行! ");
			return title;		
		}else if("NotIPMonitorRtn"==IsCanExecOrdArrear){
			title = $g("药品审核不通过,不能执行! ");
			return title;		
		}			
		return title;  
	}
	function stopExecOrderHandler(){
		if (!CheckIsCheckOrdExec()) return false;
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurS");
	    var iconCls="icon-stop-order";
	    createModalDialog("NurOrdDiag","停止执行", 380, 260,iconCls,"停止执行",Content,"MulOrdDealWithCom('NurS')");
	    //初始化原因
	    InitOECStatusChReason();
	    $('#OECStatusChReason').next('span').find('input').focus();
	}
	function stopExecPrnOrderShowHandler(rowIndex,record){
		var title="";
		if (["3","4","5"].indexOf(ServerObj.patData.patFlag)>-1){
			title=$g("病人已")+patData.flagDesc+"!";
		}
		var execStatus = record.TExecStateCode;
		var orderStatCode = record.TItemStatCode;
		if(execStatus != "C" && execStatus != "未执行") {
			title =$g( "只有未执行与撤消执行的执行记录才能停止!");
			return title ;
		}else if(orderStatCode == "U"){
			title = $g("医嘱已作废!");
			return title ;
		}else if(orderStatCode == "P"){
			title = $g("医嘱Pre-Order!");
			return title ;
		}else if(orderStatCode == "I"){
			title = $g("医嘱未核实!");
			return title ;
		}			
		return title;
	}
	function cancelExecOrderHandler(){
		if (!CheckIsCheckOrdExec()) return false;
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurC");
	    var iconCls="icon-cancel-order";
	    createModalDialog("NurOrdDiag","撤消执行", 380, 260,iconCls,"撤消执行",Content,"MulOrdDealWithCom('NurC')");
	    //初始化原因
	    InitOECStatusChReason();
	    $('#OECStatusChReason').next('span').find('input').focus();
	}
	function cancelExecOrderShowHandler(rowIndex,record){
		var title="";
		if (["3","4","5"].indexOf(ServerObj.patData.patFlag)>-1){
			this.qtitle = $g("说明");
			title = $g("病人已")+patData.flagDesc+"!";
			return false;
		}
		var execStatus = record.TExecStateCode;
		var orderStatCode = record.TItemStatCode;
		/*原先版本 
		  IsMustApplyCancelOrdexec = tkMakeServerCall("web.DHCApplication","IsMustApplyCancel",oeori);
		  没这个方法,不做了
		*/
		/*var orgText=$('#Ordlayout_main').layout('panel', 'east').panel('setTitle',OrdInfo);
		if(orgText.indexOf("申请")!=-1){
			orgText = orgText.slice(2);
		}
		if(IsMustApplyCancelOrdexec==1){
			IsMustApplyCancelText = "申请"+orgText;
		}else{
			IsMustApplyCancelText = orgText;
		}		
		this.setText(IsMustApplyCancelText);*/
		if(execStatus != "F") {
			title = $g("已执行的才能撤销!");
			return title ;
		}
		if(orderStatCode=="E"){
			title = $g("医嘱状态为执行不能撤销执行！!");
			return title ;
		}
		var applyCancelStatusCode = record.TApplyCancelStatusCode;
		if (applyCancelStatusCode=="A"){
			title = $g("已申请撤销,请等待审核!");
			return title;
		}
		if(record.IsCancelArrivedOrd==0){
			title = $g("治疗记录已经治疗,不能撤销执行!");
			return title;
		}
		return title;
	}
	function UpdateHourOrderEndTimeHandler(){
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurUpdateEndTime");
	    var iconCls="icon-ok";
	    createModalDialog("NurOrdDiag","修改小时医嘱结束时间", 380, 260,iconCls,"确定",Content,"MulOrdDealWithCom('NurUpdateEndTime')");
	    //初始化原因
	    var cbox = $HUI.combobox("#winHourEndTime", {
			editable: true,
			multiple:false,
			mode:"remote",
			method: "GET",
			selectOnNavigation:true,
		  	valueField:'id',
		  	textField:'text',
		  	data:eval("("+ServerObj.IntervalTimeListJson+")")
		});
		$("#winHourEndTime").combobox("setValue","");
	    $('#winHourEndTime').next('span').find('input').focus();
	}
	function NurUpdateHourOrdExecEndTime(){
		//调用后台修改小时医嘱结束时间
		var time=$('#winHourEndTime').combobox('getText');
	   if (time==""){
		   $.messager.alert("提示","结束时间不能为空!","info",function(){
			   $('#winHourEndTime').next('span').find('input').focus();
		   });
		   return false;
	   }
	   if (!IsValidTime(time)){
		   $.messager.alert("提示","结束时间格式不正确! 时:分:秒,如11:05:01","info",function(){
			   $('#winHourEndTime').next('span').find('input').focus();
		   });
		   return false;
	   }
	   var type="U";
	   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+"";
	   var SelOrdExecRowStr=GetSelOrdExecRowStr();
	   $.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"MulOrdExecDealWithCom",
		    OrderExecStr:SelOrdExecRowStr,
		    date:'',
		    time:time,
		    type:type,
		    ReasonId:'',
		    ExpStr:ExpStr
		},function(val){
			if (val=="0"){
				InPatOrdExecDataGrid.datagrid("clearSelections");
            	InPatOrdExecDataGrid.datagrid("clearChecked");
				LoadInPatOrdExecDataGrid();
				destroyDialog("NurOrdDiag");
			}else{
				$.messager.alert("提示",val);
				return false;
			}
		});
	}
	function InitOECStatusChReason(){
		 var cbox = $HUI.combobox("#OECStatusChReason", {
			required:true,
			editable: true,
			multiple:false,
			mode:"remote",
			method: "GET",
			selectOnNavigation:true,
		  	valueField:'id',
		  	textField:'text',
		  	data:eval("("+ServerObj.OECStatusChReasonJson+")"),
		  	onSelect:function(){
			  	$("#winPinNum").focus();
			}
		});
	}
	function UpdateHourOrderEndTimeShowHandler(rowIndex,record){
		var title="";
		if (["3","4","5"].indexOf(ServerObj.patData.patFlag)>-1){
			title = $g("病人已")+patData.flagDesc+"!";
			return title;
		}
		var IsHourOrder = record.TBillUom=="HOUR" ? true : false;
		if(!IsHourOrder){
			title = "不是小时医嘱!";
			return title ;
		}
		var execStatus = record.TExecStateCode;
		if(execStatus != "D") {
			title = "执行记录停止后才能修改时间!";
			return title ;
		}
		return title;
	}
	function NuraddOrderNotesHandler(){
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurA");
	    var iconCls="icon-add-note";
	    createModalDialog("NurOrdDiag","增加备注", 380, 260,iconCls,"增加备注",Content,"MulOrdDealWithCom('NurA')");
	    //获取执行记录已有备注
	    var rowrecord = InPatOrdExecDataGrid.datagrid('getSelected');
	    $.m({
		    ClassName:"appcom.OEOrdExec",
		    MethodName:"GetOEORIExecNotes",
		    OEORERowId:rowrecord.OrderExecId
		},function(val){
			if (val!="") $("#OrderExecNotes").val(val);
	    	$("#OrderExecNotes").focus();
		});
	}
	//护士更新执行记录备注
	function NurAddOrderNotes(){
	   var OrderExecNotes=$("#OrderExecNotes").val();
	   if (OrderExecNotes==""){
		   $.messager.alert("提示","备注为空,请填写备注!");
		   return false;
	   }
	   var rowrecord = InPatOrdExecDataGrid.datagrid('getSelected');
	   $.m({
		    ClassName:"appcom.OEOrdExec",
		    MethodName:"UpdateExecNotes",
		    OEORERowId:rowrecord.OrderExecId,
		    Notes:OrderExecNotes
		},function(val){
			if (val=="0"){
				LoadInPatOrdExecDataGrid();
		   		destroyDialog("NurOrdDiag");
			}
		});
	}
    function CheckIsCheckOrdExec(){
	   var SelOrdExecRowArr=InPatOrdExecDataGrid.datagrid('getChecked'); //医嘱处理以勾选为准,未勾选代表不处理
	   if (SelOrdExecRowArr.length==0){
		   $.messager.alert("提示","没有勾选执行记录!")
		   return false;
	   }
	   return true;
    }
    function GetSelOrdExecRowStr(){
	   var SelOrdExecRowStr=""
	   var SelOrdExecRowArr=InPatOrdExecDataGrid.datagrid('getChecked');
	   for (var i=0;i<SelOrdExecRowArr.length;i++){
		   if (SelOrdExecRowStr=="") SelOrdExecRowStr=SelOrdExecRowArr[i].OrderExecId;
		   else SelOrdExecRowStr=SelOrdExecRowStr+"^"+SelOrdExecRowArr[i].OrderExecId;
	   }
	   return SelOrdExecRowStr;
	}
    //执行记录处理公共方法,以type区分不同功能
    function MulOrdExecDealWithCom(type){
	   var date="",time="",ReasonId="",Reasoncomment="";
	   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
	   if ((type=="C")||(type=="D")){ //撤消执行 停止执行
		   ReasonId=$("#OECStatusChReason").combobox("getValue");
		   Reasoncomment=$("#OECStatusChReason").combobox("getText");
		   if (ReasonId==Reasoncomment) ReasonId="";
		   else if (ReasonId!="") Reasoncomment="";
		   if ((ReasonId=="")&&(Reasoncomment=="")){
			   $.messager.alert("提示","请选择或者填写原因!");
			   $('#OECStatusChReason').next('span').find('input').focus();
			   return false;
		   }
		   ExpStr=ExpStr+"^"+Reasoncomment;
	   }else if (type=="R"){
		   var date = $('#winRunOrderDate').datebox('getValue');
		   if (date==""){
			   $.messager.alert("提示","执行日期不能为空!");
			   $('#winRunOrderDate').next('span').find('input').focus();
			   return false;
		   }
		   if(!DATE_FORMAT.test(date)){
			   $.messager.alert("提示","执行日期格式不正确!");
			   return false;
		   }
		   var time=$('#winRunOrderTime').combobox('getText');
		   if (time==""){
			   $.messager.alert("提示","执行时间不能为空!");
			   $('#winRunOrderTime').next('span').find('input').focus();
			   return false;
		   }
		   if (!IsValidTime(time)){
			   $.messager.alert("提示","执行时间格式不正确! 时:分:秒,如11:05:01");
			   return false;
		   }
	   }
	   var SelOrdExecRowStr=GetSelOrdExecRowStr();
	   $.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"MulOrdExecDealWithCom",
		    OrderExecStr:SelOrdExecRowStr,
		    date:date,
		    time:time,
		    type:type,
		    ReasonId:ReasonId,
		    ExpStr:ExpStr
		},function(val){
			if (val=="0"){
				InPatOrdExecDataGrid.datagrid("clearSelections");
            	InPatOrdExecDataGrid.datagrid("clearChecked");
				LoadInPatOrdExecDataGrid();
				destroyDialog("NurOrdDiag");
			}else{
				$.messager.alert("提示",val);
				LoadInPatOrdExecDataGrid();
				return false;
			}
		});
    }
    //费用明细
    function execFeeDataShow(execRowId){
	   destroyDialog("execFeeDiag");
	   var Content="<table id='tabExecFee' cellpadding='5' style='margin:5px;border:none;'></table>";
	   var iconCls="";
	   createModalDialog("execFeeDiag",$g("费用明细"), 550, 350,iconCls,"",Content,"");
	    
	   var ExecFeeColumns=[[ 
		 			{field:'FeeId',hidden:true,title:''},
		 			{field:'TCancelStatu',hidden:true,title:''},
		 			{field:'TTarDesc',title:'收费项名称'},
		 			{field:'TTarCode',title:'代码'},
		 			{field:'TQty',title:'数量'},
		 			{field:'TPrice',title:'单价'},
		 			{field:'TAmount',title:'金额'},
		 			{field:'TDate',title:'记账时间'},
		 			{field:'TExtralComment',title:'原因'}
		]]
		InPatExecFeeDataGrid=$("#tabExecFee").datagrid({  
			fit : true,
			border : false,
			striped : false,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : false,
			rownumbers:true,
			pagination : true,  
			rownumbers : true,  
			pageSize: 10,
			pageList : [10,100,200],
			idField:'FeeId',
			columns :ExecFeeColumns
		});
		$.q({
		    ClassName : "web.DHCDocInPatPortalCommon",
		    QueryName : "FindOrderFee",
		    orderId : execRowId,
		    Pagerows:InPatExecFeeDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			InPatExecFeeDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		});
	}
	function ordDetailInfoShow(OrdRowID){
		websys_showModal({
			url:"dhc.orderdetailview.csp?ord=" + OrdRowID,
			title:'医嘱明细',
			iconCls:'icon-w-trigger-box',
			width:400,height:screen.availHeight-200
		});
	}
	function OpenOrderView(OEItemID){
		//$.orderview.show(OEItemID);
		websys_showModal({
			url:"dhc.orderview.csp?ord=" + OEItemID,
			title:'医嘱查看',
			iconCls:'icon-w-list',
			//width:screen.availWidth-200,height:screen.availHeight-200
            width:"96%",height:screen.availHeight-200
		});
		
	}
	function InsuNationShow(OEItemID){
		websys_showModal({
			url:"dhc.orderinsudetail.csp?OrderId=" + OEItemID+"&EpisodeID="+ServerObj.EpisodeID,
			title:$g('国家医保查看'),
			iconCls:'icon-w-list',
			width:640,height:250
		});
		}
	/**********end***************/
	function ReLoadGridDataFromOrdEntry(OrderPrior,SelOrdRowIDNext){
		InPatOrdDataGrid.datagrid("resize");
		if (OrderPrior == "ShortOrderPrior")  {
			var o=$HUI.radio("#OrderTypeOM");
			GridParams.Arg8="OM";
		}else if (OrderPrior == "OutOrderPrior"){
			var o=$HUI.radio("#OrderTypeOUT");
			GridParams.Arg8="OUT";
		}else {
			var o=$HUI.radio("#OrderTypeS");
			GridParams.Arg8="S";
		}
		//先置空选中事件，防止置值时触发LoadPatOrdDataGrid；
		//1是效率问题，2是重复触发LoadPatOrdDataGrid会与scrollview冲突，导致onLoadSuccess失效
		o.jdata.options.stateonChecked = o.jdata.options.onChecked;
		o.jdata.options.onChecked = function(){};
		///如果本身就是S，然后再给S置checked,将不会触发oncheck事件;
		//如果当前选项和需要查询的条件一致,这里注入数据,绕过这层判断,强制不刷新
		var CheckedValue=$("input[name='PriorType_Radio']:checked").val();
		if (CheckedValue==GridParams.Arg8){
			$(o.jqselector)[0].checked=true;
		}else{
			$(o.jqselector)[0].checked=false;
		}
		o.setValue(true);
		/*if (OrderPrior=="OutOrderPrior"){
			GridParams.Arg11=OrderPrior;
		}else{
			GridParams.Arg11="";
		}*/
		o.jdata.options.onChecked=o.jdata.options.stateonChecked;
		LoadPatOrdDataGrid(SelOrdRowIDNext);
		//GridParams.Arg11=""; //控制只有医嘱录入界面点击“出院带药”时，临时医嘱单只显示“出院带药”，否则显示临时医嘱+出院带药
	}
	function SelNextDocOrdBak(){
		//自动选中下一条医嘱
		var par_win=GetOrdPatWin();
		if (!par_win){return false;}
		if (typeof par_win.SetVerifiedOrder != "function"){return false;}
		var SelRowListRowData=InPatOrdDataGrid.datagrid('getSelections');
		
		var SelRowList=[];
		///删除非本页的数据
		var SelRowIndex="";
		$.each(SelRowListRowData,function(Index,RowData){
			var RowIndex=InPatOrdDataGrid.datagrid('getRowIndex',RowData.OrderId);
			if ((RowIndex>=0)){
				SelRowList.push(RowData);
				SelRowIndex=RowIndex;
			}
		});
		///本页选中的数据
		var ArrLength=SelRowList.length;
		if (ArrLength==0){
			par_win.SetVerifiedOrder("");
			return false;
		}
		var ListData = InPatOrdDataGrid.datagrid('getData');
		var i = 0;
		var opts = InPatOrdDataGrid.datagrid('options');
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);
		/*尝试下一行*/
		var NextRowIndex="";
		var FindCurrSel=0;
		/*需要翻页的页数*/
		var ScorllPageNum=0;
		for (i=start;i<ListData.originalRows.length;i++){
			//从本条医嘱往后找
			if (SelRowList[ArrLength-1].OrderId==ListData.originalRows[i].OrderId){
				FindCurrSel=1
				continue;
			}
			if (FindCurrSel==0){
				continue;
			}
			var OrderId=ListData.originalRows[i].OrderId;
			var TOeoriOeori=ListData.originalRows[i].TOeoriOeori;
			if ((TOeoriOeori=="")&&(OrderId.indexOf("||")>0)){
				NextRowIndex=i;
				break;
			}
		}
		if (NextRowIndex==""){
			/*没找到的情况下,清除选项 par_win.SetVerifiedOrder("");*/
			InPatOrdDataGrid.datagrid('unselectRow',SelRowIndex);
			return false;
		}
		var NeedPageNum=Math.ceil((NextRowIndex+1)/parseInt(opts.pageSize));
		if (opts.pageNumber!=NeedPageNum){
			InPatOrdDataGrid.datagrid('getPager').pagination('select',NeedPageNum);
		}
		NextRowIndex=(NextRowIndex)%parseInt(opts.pageSize);
		InPatOrdDataGrid.datagrid('checkRow',NextRowIndex);
	}
	var flagbig=1
	function changeBigOrder(ele){
		var par_win=GetOrdPatWin();
		if (par_win)par_win.Changebiggrid(flagbig);
		if (flagbig==1){
			flagbig=0
			$(ele).addClass('expanded');
			$("#changeBigBtn")[0].innerText=$g("缩小");
		}else{
			flagbig=1
			$(ele).removeClass('expanded');
			$("#changeBigBtn")[0].innerText=$g("放大");
		}
		/*var p = $("#OrdSearch-div > .layout-panel-center:first");
		var Height = $(window).height()-$("#OrdSearch-div").outerHeight()+p.outerHeight()-2;
		p.css({height:Height});
		window.setTimeout(function() {
			InPatOrdDataGrid.datagrid("resize");
		},300);*/
	}
	function toggleExecInfo(ele){
		var LineNum=0;
		if ($(ele).hasClass('expanded')){  //已经展开 隐藏
			$(ele).removeClass('expanded');
			$("#moreBtn")[0].innerText=$g("更多");
	    	//$("div[id^='more']").hide();
			$("div[id^='more']").each(function(index,obj){
				if ($(obj).css("display")!="none"){
					$(obj).hide();
					LineNum-=1;
				}
			})
	    	OrderViewsetHeight(LineNum);
		}else{
			$(ele).addClass('expanded');
			$("#moreBtn")[0].innerText=$g("隐藏");
	    	//$("div[id^='more']").show(); //#dashline
			$("div[id^='more']").each(function(index,obj){
				if ($(obj).css("display")=="none"){
					$(obj).show();
					LineNum+=1;
				}
			})
	    	OrderViewsetHeight(LineNum);
		}
		/*function setHeight(num){
			var p=$("#OrdSearch-div > .layout-panel-north:first");
			var Height=parseInt(p.outerHeight())+parseInt(num);
			p.css({height:Height});
			$("#OrdSearch").css({height:Height});
			//怎么有效防止强制同步布局
			var p = $("#OrdSearch-div > .layout-panel-center:first");	// get the center panel
			var Height = parseInt(p.outerHeight())-parseInt(num);
			if (ServerObj.PageShowFromWay=="ShowFromEmr"){
				if (+num>0) p.css({top:120,height:Height});
				else p.css({top:80,height:Height});
			}else{
				if (+num>0) p.css({top:81,height:Height});
				else p.css({top:44,height:Height});
			}
			InPatOrdDataGrid.datagrid("resize");
		}
		function setHeightBak(num){
	        var c=$("#OrdSearch-div");
	        var p=c.layout('panel', 'north');
	        var Height=parseInt(p.outerHeight())+parseInt(num);
	        p.panel('resize',{height:Height}); 
	        
			var p = c.layout('panel','center');	// get the center panel
			var Height = parseInt(p.outerHeight())-parseInt(num);
			p.panel('resize', {height:Height})
			if (ServerObj.PageShowFromWay=="ShowFromEmr"){
				if (+num>0) p.panel('resize',{top:124});
				else p.panel('resize',{top:84});
			}else{
				if (+num>0) p.panel('resize',{top:84});
				else p.panel('resize',{top:44});
			}
	    }*/
	}
	function GetArrayDefaultData(Arr){
		var DefaultData="";
		for (var i=0;i<Arr.length;i++){
			if (typeof Arr[i].selected !="undefiend"){
				if (Arr[i].selected == true){
					DefaultData=Arr[i].id;
				}
			}
			if (DefaultData!=""){
				break;
			}
		}
		return DefaultData;
	}
	
	function ExeCASigin(OrdList)
	{
		if (ServerObj.CAInit!=1){
			return true;
		}
		var ContainerName="";
		var caIsPass=0;
		var rtn=dhcsys_getcacert();
        if (rtn.IsSucc){
			if (rtn.ContainerName==""){
				ContainerName="";
        		caIsPass=0;
			}else{
				ContainerName=rtn.ContainerName;
        		caIsPass=1;
			}
		}
		if (caIsPass==0){
			alert($g("签名失败"));
            return false;
		}
		if (OrdList!=""){
			var ret=SaveCASign(ContainerName,OrdList,"S");
		}
		return true;
	}
	function SaveCASign(ContainerName,OrdList,OperationType) 
	{    try{
	      if (ContainerName=="") return false;
			//1.批量认证
		    var CASignOrdStr="";
		    var TempIDs=OrdList.split("^");
			var IDsLen=TempIDs.length;
			for (var k=0;k<IDsLen;k++) {
				/*var TempNewOrdDR=TempIDs[k].split("&");
				if (TempNewOrdDR.length <=0) continue;
				var newOrdIdDR=TempNewOrdDR[0];
				if (newOrdIdDR.indexOf("!")>0){
					newOrdIdDR=newOrdIdDR.split("!")[0];
				}*/

				var TempNewOrdDR=TempIDs[k].split(String.fromCharCode(1));
				if (TempNewOrdDR.length <=0) continue;
				var newOrdIdDR=TempNewOrdDR[0];
				if (newOrdIdDR.indexOf("!")>0){
					newOrdIdDR=newOrdIdDR.split("!")[0];
				}
				if(CASignOrdStr=="")CASignOrdStr=newOrdIdDR;
				else CASignOrdStr=CASignOrdStr+"^"+newOrdIdDR;			
			}
			var SignOrdHashStr="",SignedOrdStr="",CASignOrdValStr="";
			var CASignOrdArr=CASignOrdStr.split("^");
			for (var count=0;count<CASignOrdArr.length;count++) {
				var CASignOrdId=CASignOrdArr[count];
				var OEORIItemXML=cspRunServerMethod(ServerObj.GetOEORIItemXMLMethod,CASignOrdId,OperationType);
				var OEORIItemXMLArr=OEORIItemXML.split(String.fromCharCode(2));
				for (var ordcount=0;ordcount<OEORIItemXMLArr.length;ordcount++) {
					if (OEORIItemXMLArr[ordcount]=="")continue;
	  				var OEORIItemXML=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[1];
	   				var OEORIOperationType=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[0];
					//$.messager.alert("警告","OEORIItemXML:"+OEORIItemXML);
					var OEORIItemXMLHash=HashData(OEORIItemXML);
					//$.messager.alert("警告","HashOEORIItemXML:"+OEORIItemXMLHash);
					if(SignOrdHashStr=="") SignOrdHashStr=OEORIItemXMLHash;
					else SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&"+OEORIItemXMLHash;
					//$.messager.alert("警告",ContainerName);
					var SignedData=SignedOrdData(OEORIItemXMLHash,ContainerName);
					if(SignedOrdStr=="") SignedOrdStr=SignedData;
					else SignedOrdStr=SignedOrdStr+"&&&&&&&&&&"+SignedData;
					if(CASignOrdValStr=="") CASignOrdValStr=OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
					else CASignOrdValStr=CASignOrdValStr+"^"+OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
				}
			}
			if (SignOrdHashStr!="")SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&";
			if (SignedOrdStr!="")SignedOrdStr=SignedOrdStr+"&&&&&&&&&&";
			//获取客户端证书
	    	var varCert = GetSignCert(ContainerName);
	    	var varCertCode=GetUniqueID(varCert);
			/*
			alert("CASignOrdStr:"+CASignOrdStr);
			alert("SignOrdHashStr:"+SignOrdHashStr);
			alert("varCert:"+varCert);
			alert("SignedData:"+SignedOrdStr);
			*/
	    	if ((CASignOrdValStr!="")&&(SignOrdHashStr!="")&&(varCert!="")&&(SignedOrdStr!="")){
				//3.保存签名信息记录																												CASignOrdValStr,session['LOGON.USERID'],"A",					SignOrdHashStr,varCertCode,SignedOrdStr,""
				var ret=cspRunServerMethod(ServerObj.InsertCASignInfoMethod,CASignOrdValStr,session['LOGON.USERID'],OperationType,SignOrdHashStr,varCertCode,SignedOrdStr,"");
				if (ret!="0") {
					alert($g("数字签名没成功"));
					return false;
				}else{
					alert("CA sucess")
				}
			}else{
		  		alert($g("数字签名错误"));
		  		return false;
			} 
			return true;
		}catch(e){alert($g("CA err:")+e.message);return false;}
	}
	function cancelPreStopOrdHandle(){
		//MulOrdDealWithCom("CancelPreStopOrd");
		if (!CheckIsCheckOrd()) return false;
	    destroyDialog("OrdDiag");
	    var Content=initDiagDivHtml("CancelPreStopOrd")
	    var iconCls="icon-w-edit";
	    createModalDialog("OrdDiag","撤销预停", 380, 260,iconCls,"撤销预停",Content,"MulOrdDealWithCom('CancelPreStopOrd')");
	    $('#winPinNum').focus();
	}
	function cancelPreStopOrdShowHandle(rowIndex,record){
		var title=$g("非预停状态医嘱!");
		if (record.TStopDate!=""){
			var stopDate=record.TStopDate.split(" ")[0];
			if ((stopDate!="")&&(CompareDate(stopDate,ServerObj.CurrentDate))){
				title="";
			}
		}
		var stopTitle=stopOrderShowHandler(rowIndex,record);
		if (stopTitle!=""){
			title=$g(stopTitle)
		}
		return title;
	}
	function CompareDate(date1,date2){
		var date1 = myparser(date1);
		var date2 = myparser(date2); 
		if(date2<date1){  
			return true;  
		} 
		return false;
	}

	function OrdListResize(MaxH){
		//var MaxH=$("#OrdSearch-div").outerHeight();
		var NorthH=$("#OrdSearch-div > .layout-panel-north:first").outerHeight();
		var Height=parseInt(MaxH)-parseInt(NorthH);
		var p = $("#OrdSearch-div > .layout-panel-center:first");
		p.css({height:Height});
		InPatOrdDataGrid.datagrid("resize");
	}
	function InitPatOrderViewGlobal(EpisPatInfo){
		var EpisPatObj=eval("("+EpisPatInfo+")");
		var adm=EpisPatObj.EpisodeID;
		var adm="";
		var frm = dhcsys_getmenuform();
	    if (frm) {
	    	adm = frm.EpisodeID.value;
	    }
		/*if ((typeof ServerObj.EpisodeID !="undefined")&&(adm==ServerObj.EpisodeID)){
			return;
		}*/
		
		var FixedEpisodeID="";
		if ((parent)&&((parent.FixedEpisodeID)&&(typeof parent.FixedEpisodeID!="undefined"))){
			FixedEpisodeID=parent.FixedEpisodeID;
		}
		if ((parent.parent.FixedEpisodeID)&&(typeof parent.parent.FixedEpisodeID!="undefined")){
			FixedEpisodeID=parent.parent.FixedEpisodeID;
		}
		// 若标识switchSysPat为N,用的是request内的病人,且不能切换病人
		if ((parent.switchSysPat)&&(parent.switchSysPat=="N")) {
			FixedEpisodeID=EpisPatObj.EpisodeID;
		}
		//当右键刷新时，会定位到最初选择的患者
		if ((adm!=EpisPatObj.EpisodeID)&&(adm!="")&&(FixedEpisodeID!=EpisPatObj.EpisodeID)){
			EpisPatInfo=GetEpisPatInfo(adm);
			delete EpisPatObj;
			EpisPatObj=eval("("+EpisPatInfo+")");
		}
		//.replace(/\//g,"\\")
		//.replace(/\\{2,}/g,"\\")
		//EpisPatObj.PatAdmInfoJson=EpisPatObj.PatAdmInfoJson	//?EpisPatObj.PatAdmInfoJson.replace(/\\{2,}/g,"\\"):"";
		EpisPatObj.OrdDoctorList=EpisPatObj.OrdDoctorList	//?EpisPatObj.OrdDoctorList.replace(/\\{2,}/g,"\\"):"";
		EpisPatObj.patData=EpisPatObj.patData	//?EpisPatObj.patData.replace(/\\{2,}/g,"\\"):"";
		EpisPatObj.EmrQualityQtyJson=EpisPatObj.EmrQualityQtyJson	//?EpisPatObj.EmrQualityQtyJson.replace(/\\{2,}/g,"\\"):"";
		EpisPatObj.MessageMarquee=EpisPatObj.MessageMarquee		//?EpisPatObj.MessageMarquee.replace(/\\{2,}/g,"\\"):"";
		
		$.extend(ServerObj,EpisPatObj);
		
		var doctorListData=ServerObj.OrdDoctorList;
		$.extend(GridParams,{
			"Arg1":ServerObj.PatientID,
			"Arg2":ServerObj.EpisodeID,
			"Arg3":doctorListData[0].id
		});
		$.extend(ServerObj,{
			ViewInstrJson:eval(EpisPatObj.ViewInstrJson),
			ViewFreqJson:eval(EpisPatObj.ViewFreqJson)
		});
		return;
	}
	function GetEpisPatInfo(adm){
		var EpisPatInfo=$.cm({
		    ClassName : "web.DHCDocViewDataInit",
		    MethodName : "InitPatInfoView",
		    EpisodeID : adm,
		    dataType:"text"
		},false);
		EpisPatInfo=EpisPatInfo.replace(/\\'/g,"'");
		//EpisPatInfo=EpisPatInfo.replace(/\\\\/g,"/\/");
		return EpisPatInfo;
	}
	function xhrRefresh(adm,CallBackFunc){
		var EpisPatInfo=GetEpisPatInfo(adm);
		InitPatOrderViewGlobal(EpisPatInfo);
		var doctorListData=ServerObj.OrdDoctorList
		$HUI.combobox("#doctorList", {
			data: doctorListData,
		});
		$HUI.combobox("#InstrDesc", {
			data:ServerObj.ViewInstrJson
		});
		GridParams.Arg12="";
		$HUI.combobox("#SFreq", {
			data:ServerObj.ViewFreqJson
		});
		GridParams.Arg13="";
		$("#orderDesc").val("");
		GridParams.Arg7="";
		$("#MessageMarquee").html(ServerObj.MessageMarquee);
		OrdExecGridParams.Arg1="";
		if (InPatOrdDataGrid){InPatOrdDataGrid.datagrid('unselectAll').datagrid('uncheckAll');}
		if (typeof InPatOrdExecDataGrid !="undefined"){
			InPatOrdExecDataGrid.datagrid("unselectAll").datagrid('loadData',[]);
			$('#Ordlayout_main').layout('panel', 'east').panel('setTitle',"");
		}
		if (ServerObj.PageShowFromWay!="ShowFromOrdCopy"){
			$("#OrdReSubCatList .tabs").css('width', "100%");
			$('#OrdSearch-div').layout('resize');
			$('#OrdReSubCatList').tabs('resize');
			$("#OrdReSubCatList .tabs-wrap").css('width', "100%");
		}
		//防止部分浏览器局部刷新时页面显示空白
		ForceRefreshLayout();
		//关闭所有的dialog,window,message
		$(".panel-body.window-body").each(function(index,element){
			// 治疗记录/治疗方案弹框不能调用destroy方法，会导致局部刷新后再次点击按钮不会弹出框
			if (($(element)[0].id =="cure-record-dialog") ||($(element)[0].id =="cure-detail-dialog")||($(element)[0].id =="Datedialog")) {
				$(element).window("close");
			}else{
				$(element).window("destroy");
			}
		});
		InPatOrdDataGridLoadSuccCallBack.add(CallBackFunc);
		/*
		///tanjishan 2019-07-08屏蔽，汪工已修正短时间内调用多次xrh方法的bug，不会再出现onloadsuccess不调用的问题
		if (CallBackFunc) {
			InPatOrdDataGridLoadSuccCallBack.CallBackFunc=CallBackFunc();
		}
		*/
		//InittabInPatOrd();
		RefreshDocToDoListView();
		setTimeout(function() {
			if (($("#moreBtn")[0].innerText==$g("隐藏"))&&(ServerObj.PageShowFromWay!="ShowFromEmrList")){
	    		var p = $("#OrdSearch")
	    		if ((p.height()<=84)&&((ServerObj.PageShowFromWay=="ShowFromEmr"))){
					OrderViewsetHeight(1)
	    		}else if ((p.height()<82)&&((ServerObj.PageShowFromWay!="ShowFromEmr"))){
		    		OrderViewsetHeight(1)
		    		}
		    	LoadPatOrdDataGrid("");
			}else{
				LoadPatOrdDataGrid("");
				}
		},1000)
	}
	/**
	 * 设置检索区的高度，并根据其高度计算医嘱浏览表格的top值与高度自动适配
	 * @param {int} num 查询条件对应的增删行数，1：增加一行，-1：减少一行
	 */
	function OrderViewsetHeight(num){
		var p=$("#OrdSearch-div > .layout-panel-north:first");	//北部区域
		//如果more出现滚动条，则把more拆分成more和more2
		if ($("#more").prop("scrollWidth")>$("#more").prop("clientWidth")){	//宽度过小，为防止自动折行，把多余的元素全部迁移到新行上
			var more2=$("<div id='more2' class='fixedh2-div'></div>")
			for (var i = 10; i < $("#more").children().length; i++) {
				more2.append($($("#more").children()[i]).detach());
				i=i-1;
			}
			$("#OrdSearch").append(more2);
			num=num+1;		//增加一行
		}else{
			if ($("#more2").length===1){
				for (var i = 0; i < $("#more2").children().length; i++) {
					$("#more").append($($("#more2").children()[i]).detach());
					i=i-1;
				}
				if ($("#more2").css("display")!="none"){
					num=num-1;		//删除一行
				}
				$("#more2").remove();
			}
		}
		//console.log("num:"+num)
		if (num==0){return}
		num=parseInt(num);
		var lineHeight=41;
		var Height=parseInt(p.outerHeight())+(lineHeight*num);
		p.css({height:Height});
		//设置检索区域的高度
		$('#OrdSearch-div').layout('panel', 'north').panel('options').height=Height;
		$('#OrdSearch-div').layout('resize');
		if (ServerObj.PageShowFromWay!="ShowFromEmr"){
			InPatOrdDataGrid.datagrid("resize");
		}
		// setTimeout(function(){
		// 	$('#pInPatOrd').parent().height($('#pInPatOrd').parent().parent().height()-$('#pInPatOrd').parent().prev().height());
		// 	$('#pInPatOrd').width($('#pInPatOrd').parent().width());
		// 	$('#pInPatOrd').height($('#pInPatOrd').parent().height());
		// 	if ((ServerObj.PageShowFromWay!="ShowFromEmr")){
		// 		InPatOrdDataGrid.datagrid("resize");
		// 	}
		// },500);
	}

   function getRefData(){
	   var rtnObj= {data:"",toTitle:"",msg:"",success:true};
	   var SelRowListRowData=InPatOrdDataGrid.datagrid('getSelections');
	   if (SelRowListRowData.length==0){
		   $.extend(rtnObj, { msg: $g("未选择需要操作的行数据!"),success:false});
		   return rtnObj;
	   }
	   var oeoris="",CMoeoris="";
	   for (var i=0;i<SelRowListRowData.length;i++){
		   if (SelRowListRowData[i].OrderId==""){
			   continue;
		   }
		   var OrderId=SelRowListRowData[i].OrderId;
		   if (SelRowListRowData[i].IsCNMedItem==1) {
			   if (CMoeoris=="") CMoeoris=OrderId;
			   else CMoeoris=CMoeoris+"^"+OrderId;
		   }else{
			   if (oeoris=="") oeoris=OrderId;
			   else oeoris=oeoris+"^"+OrderId;
		   }
	   }
	   if ((oeoris=="")&&(CMoeoris=="")){
		   $.extend(rtnObj, { msg: $g("未选择需要操作的行数据!"),success:false});
		   return rtnObj;
	   }
	   if ((oeoris!="")&&(CMoeoris!="")) {
		   $.extend(rtnObj, { msg: $g("西药和草药不能同时复制!"),success:false});
		   return rtnObj;
	   }
	   var toTitle=$g("医嘱录入");
	   if (oeoris=="") oeoris=CMoeoris,toTitle=$g("草药录入");
	   oeoris=oeoris.split("^").sort(function(num1,num2){
	       return parseFloat(num1.split("||")[1])-parseFloat(num2.split("||")[1]);
	   }).join("^");
	   $.extend(rtnObj, { data: oeoris,toTitle:toTitle});
	   return rtnObj;
   }
   ///获取右键按钮权限提示信息
   function GetOrdDealPermissionTitle(){
	   var SelOrdRowArr=InPatOrdDataGrid.datagrid('getChecked');
	   var OrderId=SelOrdRowArr[0].OrderId;
	   var OperTypeStr="S^C^U";
	   OrdRightTitleJson=$.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"GetOrdDealPermissionTitle",
		    OrderId:OrderId,
		    OperTypeStr:OperTypeStr,
		    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^"
	   },false);
	   OrdRightTitleJson=eval("("+OrdRightTitleJson+")");
   }
   function ForceRefreshLayout(){
		var MaxWidth=$('#Ordlayout_main').parent().width();
		var MaxHeight=$('#Ordlayout_main').parent().height()
		$('#Ordlayout_main').layout('resize',{
			width:MaxWidth+"px",
			height:MaxHeight+"px"
		});
		var p = $("#OrdSearch-div > .layout-panel-center:first");
		p.css({height:(MaxHeight-80)+"px"});
		$("#OrdSearch-div > .layout-panel-center:first > div").css('width','100%')
		InPatOrdDataGrid.datagrid("resize");
	}
	function RefreshDocToDoListView(){
		if ($("#DocToDoListView").length>0){
			var frm=$("#DocToDoListViewFrame").get(0).contentWindow;
			frm.xhrRefresh({
				adm:ServerObj.EpisodeID,
	        	papmi:ServerObj.PatientID
			});
			return true;
		}
		ServerObj.DefaultOrdList="";
	}
	
	function OpenDocToDoListView(){
		websys_showModal({
			url:"ipdoc.doctodolistview.hui.csp?PatientID="+ServerObj.PatientID+"&EpisodeID="+ServerObj.EpisodeID,
			title:'医疗待办',
			width:'75%',height:'80%',
			left:200,top:100
		})
	}
	function ShowExamInfo(OrdID,OrderName)
	{
		var src='ipdoc.order.detail.csp?OEORIRowid='+OrdID;
		if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
		$(window.event.target).webuiPopover({
			width:450,
			height:140,
			title:OrderName,
			content:"<iframe width='99.5%' height='99%' frameborder='0' src='"+src+"'></iframe>",
			trigger:'hover'
		}).webuiPopover('show');
	}
	//复制下拉菜单
	function InitOrdCopyMenu(){
		$('#OrderCopyMenu').menu({
			onShow:function(){
			},
			onClick:function(item){
				var type=$(item.target).attr('key');
				copyOrderHandler(type);
			}
		});
		$('#OrdCopy_Toolbar').empty().splitbutton({  
			text:'复制',
			iconCls: 'icon-copy',
			menu: '#OrderCopyMenu'
		}).addClass('menubutton-toolbar');
	}
	//医嘱保存为医嘱套、医嘱模板、用户常用
	function InitOrdSaveMenu(){
		$('#OrderSaveMenu').menu({
			onShow:function(){
				InitOrdFavSaveMenu();
			},
			onClick:function(item){
				if(item.text==$g('医嘱套')){
					OrdSaveToARCOS();
				}else if(item.text==$g('用户常用')){
					OrdSaveToUserDef();
				}
			}
		});
		$('#OrdSave_Toolbar').empty().menubutton({  
			text:'另存为', 
			iconCls: 'icon-redo',   
			menu: '#OrderSaveMenu'
		}).addClass('menubutton-toolbar');
	}
	function GetOrdSaveData(SaveType){
		var CNMedFlag=false;
		var OrdItemIDArr=new Array();
		var OrdItemRows=new Array();
		var SelOrdRowArr=InPatOrdDataGrid.datagrid('getChecked');
		for (var i=0;i<SelOrdRowArr.length;i++){
			if (SelOrdRowArr[i].OrderId=="") continue;
			var OrdCNMedFlag=(SelOrdRowArr[i].IsCNMedItem=='1');
			if(OrdItemIDArr.length&&CNMedFlag!=OrdCNMedFlag){
				return {code:-1,msg:'不能同时保存草药与非草药医嘱'};
			}
			if(SaveType=='UserDef'){
				if(OrdCNMedFlag||(SelOrdRowArr[i].OrderType!='R')){
					continue;
				}
			}
			CNMedFlag=OrdCNMedFlag;
			OrdItemIDArr.push(SelOrdRowArr[i].OrderId);
			OrdItemRows.push(SelOrdRowArr[i]);
		}
		if(!OrdItemIDArr.length){
			if(SaveType=='UserDef') return {code:-1,msg:'未选择有效的西药医嘱'};
			return {code:-1,msg:'未选择有效医嘱'};
		}
		return {code:0,CNMedFlag:CNMedFlag,OrdItemIDArr:OrdItemIDArr,OrdItemRows:OrdItemRows};
	}
	function InitOrdFavSaveMenu(){
		var OrdSaveData=GetOrdSaveData();
		var CONTEXT=OrdSaveData.CNMedFlag?'W50007':'WNewOrderEntry';
		$('div[name="menucopy"]').each(function(){
			$('#OrderSaveMenu').menu('removeSubMenu',this);
			if(OrdSaveData.code!=0) return true;
			var target=this;
			var key=$(target).attr('key');
			$.cm({ 
				ClassName:"DHCDoc.Order.Fav",
				MethodName:"GetFavData", 
				Type:key,
				CONTEXT:CONTEXT, 
				LocID:session['LOGON.CTLOCID'],
				UserID:session['LOGON.USERID'],
				OnlyCatNode:1
			},function(data){
				$.each(data,function(index, value){
					if (value .children.length==0){
						$('#OrderSaveMenu').menu('appendItem', {
							parent:target,
							text:value.text,
							onclick:function(){
								$.messager.alert('提示','不能保存到'+value.text);
							}
						});
					}else{
						$('#OrderSaveMenu').menu('appendItem',{
							parent:target,
							text:value.text
						});
					}
					var submenu=$('#OrderSaveMenu').menu('getSubMenu',target);
					var subTarget=submenu.children("div.menu-item:last")[0];
					$.each(value.children,function(index, value){
						$('#OrderSaveMenu').menu('appendItem', {
							parent:subTarget,
							text:value.text,
							onclick:function(){
								var OrdSaveData=GetOrdSaveData();
								if(OrdSaveData.code!=0){
									$.messager.popover({msg:OrdSaveData.msg,type:'alert'});
									$(this).menu('hide');
									return;
								}
								var ret=$.cm({ 
									ClassName:"DHCDoc.Order.Fav",
									MethodName:"InsertByOrdItems", 
									OrdItemIDStr:JSON.stringify(OrdSaveData.OrdItemIDArr),
									SubCatID:value.id,
									UserID:session['LOGON.USERID'],
									LogonHospID:session['LOGON.HOSPID'],
									dataType:'text'
								},false);
								if(ret=='0'){
									$.messager.popover({msg:"保存成功",type:'success'});
									if(parent.refreshTemplate) parent.refreshTemplate();
								}else{
									$.messager.alert('提示','保存失败:'+ret);
								}
							}
						});
					});
				});
			});	
		});
	}
	function OrdSaveToARCOS(){
		var OrdSaveData=GetOrdSaveData();
		if(OrdSaveData.code!=0){
			$.messager.popover({msg:OrdSaveData.msg,type:'alert'});
			return;
		}
		new Promise(function(parResolve,rejected){
			var loopRow=function(index){
				if(index<0){
					parResolve();
					return;
				}
				var row=OrdSaveData.OrdItemRows[index];
				new Promise(function(resolve,rejected){
					if(row.BindSourceDesc!=''){
						$.messager.confirm('提示','【'+row.OriginaName+'】为['+row.BindSourceDesc+'],是否仍然保存到医嘱套?',function(r){
							if(!r){
								OrdSaveData.OrdItemIDArr.splice(index,1);
							}
							resolve()
						});
					}else{
						resolve()
					}
				}).then(function(){
					loopRow(--index);
				})
			}
			loopRow(OrdSaveData.OrdItemRows.length-1);
		}).then(function(){
			if(!OrdSaveData.OrdItemIDArr.length){
				return;
			}
			var CMFlag=OrdSaveData.CNMedFlag?'Y':'N';
			var PreCMPrescTypeCode='';
			if(CMFlag=='Y'){
				PreCMPrescTypeCode=$.cm({
					ClassName:'web.UDHCPrescript',
					MethodName:'GetOrdCMPrescTypeCode',
					OrdItemID:OrdSaveData.OrdItemIDArr[0],
					dataType:'text'
				},false);
			}
			var lnk = "udhcfavitem.edit.hui.csp?TDis=1&CMFlag="+CMFlag+'&PreCMPrescTypeCode='+PreCMPrescTypeCode;  //&CMFlag=N&HospARCOSAuthority=1"; //udhcfavitem.edit.new.csp
			websys_showModal({
				url:lnk,
				title:$g('医嘱套维护 ')+"<span style='color:"+(HISUIStyleCode=="lite"?"#FF9933":"#FFB746")+"'>"+$g('提示：需新增医嘱套请右键点击【新增】;需保存到已存在的医嘱套中,请双击对应行')+'</span>',
				width:760,height:(top.screen.height - 300),
				CallBackFunc:function(rtn){
					var ArcosRowid = rtn.split("^")[0];
					if (ArcosRowid) { 
						var ret=$cm({
							ClassName:'web.DHCARCOrdSets',
							MethodName:'InsertByOrdItems',
							ARCOSRowid:ArcosRowid,
							OrdItemIDStr:JSON.stringify(OrdSaveData.OrdItemIDArr), 
							UserID:session['LOGON.USERID'],
							LogonHospID:session['LOGON.HOSPID'],
							dataType:'text'
						},false);
						if(ret=='0'){
							$.messager.popover({msg:"保存成功",type:'success'});
						}else{
							$.messager.alert('提示','保存失败:'+ret);
						}
					}else{ 
						$.messager.alert("警告", "保存失败!"); 
						return websys_cancel(); 
					}
				}
			});
		})
	}
	function OrdSaveToUserDef(){
		var OrdSaveData=GetOrdSaveData("UserDef");
		if(OrdSaveData.code!=0){
			$.messager.popover({msg:OrdSaveData.msg,type:'alert'});
			return;
		}
		var ret=$cm({
			ClassName:'web.DHCDocItemDefault',
			MethodName:'InsertByOrdItems',
			OrdItemIDStr:JSON.stringify(OrdSaveData.OrdItemIDArr), 
			UserID:session['LOGON.USERID'],
			PAAdmType:"I",
			LogonHospID:session['LOGON.HOSPID'],
			dataType:'text'
		},false);
		if(ret=='0'){
			$.messager.popover({msg:"保存成功",type:'success'});
		}else{
			$.messager.alert('提示','保存失败:'+ret);
		}
	}
	function OrderSpecLocDiagShowHandler(rowIndex,record){
	    var title="";
		if (record.OrdSpecLocDiagCatCode==""){
			title=$g("未关联有效的专科表单!");
		}
		return title;
	}
	function OrderSpecLocDiagHandler(){
		var OrdSerialNum="",OrdSpecDiagnosForm="",OrdSpecLocDiagCatCode=""
		var SelOrdRowArr=InPatOrdDataGrid.datagrid('getChecked');
		for (var i=0;i<SelOrdRowArr.length;i++){
			if (SelOrdRowArr[i].OrderId==""){
				 continue;  
			}
			OrdSerialNum=SelOrdRowArr[i].OrdSerialNum;
			OrdSpecDiagnosForm=SelOrdRowArr[i].OrdSpecDiagnosForm;
			OrdSpecLocDiagCatCode=SelOrdRowArr[i].OrdSpecLocDiagCatCode;
		}
		
		var url="opdoc.specloc.diag.csp?EpisodeID="+ServerObj.EpisodeID+"&PatientID="+ServerObj.PatientID+"&SpecLocDiagCatCode="+OrdSpecLocDiagCatCode+"&SerialNum=ord|"+OrdSerialNum;
		websys_showModal({
			iconCls:'icon-w-edit',
			url:url,
			title:OrdSpecDiagnosForm+$g(' 填写'),
			width:OrdSpecLocDiagCatCode=='KQMB'?"95%":400,
			height:700,
			closable:true,
			callBackRetVal:"",
			onBeforeClose:function(){
				// if (parseInt(websys_showModal("options").callBackRetVal)>0) {
				// 	ReturnObj.SuccessFlag=true;
				// }else{
				// 	$.messager.alert("提示", $g("未填写转科表单"),"info",function(){
				// 		ReturnObj.SuccessFlag=false;
				// 	});
				// }
			},
			CallBackFunc:function(retval){
				if (typeof retval=="undefined") retval="";
				websys_showModal("options").callBackRetVal=retval;
				websys_showModal("close");
			}
		})
		
	}
   	return {
	   "InitInPatOrd":InitInPatOrd,
	   "myformatter":myformatter,
	   "myparser":myparser,
	   "LoadPatOrdDataGrid":LoadPatOrdDataGrid,
	   "DiagDivKeyDownHandle":DiagDivKeyDownHandle,
	   "stopOrderHandler":stopOrderHandler,
	   "stopOrderShowHandler":stopOrderShowHandler,
	   "cancelOrderShowHandler":cancelOrderShowHandler,
	   "cancelOrderHandler":cancelOrderHandler,
	   "abortOrderHandler":abortOrderHandler,
	   "abortOrderShowHandler":abortOrderShowHandler,
	   "addOrderNotesHandler":addOrderNotesHandler,
	   "addOrderNotesShowHandler":addOrderNotesShowHandler,
	   "consultationHandler":consultationHandler,
	   "consultationShowHandler":consultationShowHandler,
	   "surgeryApplyHandler":surgeryApplyHandler,
	   "surgeryApplyShowHandler":surgeryApplyShowHandler,
	   "addExecOrderHandler":addExecOrderHandler,
	   "addExecOrderShowHandler":addExecOrderShowHandler,
	   //撤销预停
	   "cancelPreStopOrdHandle":cancelPreStopOrdHandle,
	   "cancelPreStopOrdShowHandle":cancelPreStopOrdShowHandle,
	   //以下方法,原版本未做实现,此版本只发布接口
	   "bloodApplyHandler":bloodApplyHandler,
	   "bloodApplyShowHandler":bloodApplyShowHandler,
	   "addBillOrderHandler":addBillOrderHandler,
	   "freeExecOrderHandler":freeExecOrderHandler,
	   "freeExecOrderShowHandler":freeExecOrderShowHandler,
	   "cancelFreeExecOrderHandler":cancelFreeExecOrderHandler,
	   "cancelFreeExecOrderShowHandler":cancelFreeExecOrderShowHandler,
	   "addFeeExecOrderHandler":addFeeExecOrderHandler,
	   "addFeeExecOrderShowHandler":addFeeExecOrderShowHandler,
	   "OrderZSQShowHandler":OrderZSQShowHandler,
	   "OrderZSQHandler":OrderZSQHandler,
	   //*****************end******************
	   "ChangeOrderDoseQtyShowHandler":ChangeOrderDoseQtyShowHandler,
	   "ChangeOrderDoseQtyHandler":ChangeOrderDoseQtyHandler,
	   
	   "runExecOrderHandler":runExecOrderHandler,
	   "runExecOrderShowHandler":runExecOrderShowHandler,
	   "stopExecOrderHandler":stopExecOrderHandler,
	   "stopExecPrnOrderShowHandler":stopExecPrnOrderShowHandler,
	   "cancelExecOrderHandler":cancelExecOrderHandler,
	   "cancelExecOrderShowHandler":cancelExecOrderShowHandler,
	   "cancelExecOrderShowHandler":cancelExecOrderShowHandler,
	   "UpdateHourOrderEndTimeHandler":UpdateHourOrderEndTimeHandler,
	   "UpdateHourOrderEndTimeShowHandler":UpdateHourOrderEndTimeShowHandler,
	   "NuraddOrderNotesHandler":NuraddOrderNotesHandler,
	   "OrderSpecLocDiagHandler":OrderSpecLocDiagHandler,
	   "OrderSpecLocDiagShowHandler":OrderSpecLocDiagShowHandler,

	   "execFeeDataShow":execFeeDataShow,
	   "ordDetailInfoShow":ordDetailInfoShow,
	   "OpenOrderView":OpenOrderView,
	   "ReLoadGridDataFromOrdEntry":ReLoadGridDataFromOrdEntry,
	   "SetVerifiedOrder":SetVerifiedOrder,
	   "SelNextDocOrd":SelNextDocOrd,
	   "BubbleKeyDown":BubbleKeyDown,
	   "ShowOrderDescDetail":ShowOrderDescDetail,
	   "toggleExecInfo":toggleExecInfo,
	   "changeBigOrder":changeBigOrder,
	   "InitPatOrderViewGlobal":InitPatOrderViewGlobal,
	   "GetEpisPatInfo":GetEpisPatInfo,
	   "xhrRefresh":xhrRefresh,
	   "OrdListResize":OrdListResize,
	   "getRefData":getRefData,
	   "StopTimeFocusJump":StopTimeFocusJump,
	   "ShowExamInfo":ShowExamInfo,
	   "InsuNationShow":InsuNationShow
   }
})();