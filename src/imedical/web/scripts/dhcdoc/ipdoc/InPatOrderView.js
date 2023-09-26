var opl=ipdoc.lib.ns("ipdoc.patord");
opl.view=(function(){
   function InitInPatOrd(){
	   InittabInPatOrd();
	   InitPageItemEvent();
	   if (ServerObj.PageShowFromWay=="ShowFromEmr"){
		   OrdReSubCatList();
		   $("#MessageMarquee").html(ServerObj.MessageMarquee);
	   }
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
	        ,"Arg11":"","ClassName":"web.DHCDocInPatPortalCommon","QueryName":"FindInPatOrder"
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
			height:MaxHeight
			
		});
		$(that).webuiPopover('show');
	}
	var selRowIndex="";
	function InittabInPatOrd(){
		if (ServerObj.OrdrightKeyMenuHidden=="true"){
			var OrdToolBar="";
		}else{
			var OrdToolBar=[{
	            text: '开医嘱',
	            iconCls: 'icon-write-order',
	            handler: function() {
		            if (typeof parent.switchTabByEMR =="function"){
						//parent.switchTabByEMR("dhc_side_oe_oerecord");
						parent.switchTabByEMR($g("医嘱录入"));
					}
		        }
	        },'-',{
	            text: '复制',
	            iconCls: 'icon-copy',
	            handler: function() {copyOrderHandler(""); }
	        },{
	            text: '复制为临时',
	            iconCls: 'icon-copy-sos',
	            handler: function() {copyOrderHandler("NORM"); }
	        },{
	            text: '复制为长期',
	            iconCls: 'icon-copy-prn',
	            handler: function() {copyOrderHandler("S");}
	        },{
	            text: '复制为出院带药',
	            iconCls: 'icon-copy-drug',
	            handler: function() { copyOrderHandler("OUT");}
	        },{
	            text: '复制为虚拟长期',
	            iconCls: 'icon-copy-prn',
	            handler: function() { copyOrderHandler("VirLong");}
	        },'-', {
	            text: '停医嘱',
	            iconCls: 'icon-stop-order',
	            handler: function() {ShowStopMulOrdWin();}
	        },{
	            text: '撤销',
	            iconCls: 'icon-cancel-order',
	            handler: function() {ShowCancelMulOrdWin();}
	        },{
	            text: '作废',
	            iconCls: 'icon-abort-order',
	            handler: function() {ShowUnUseMulOrdWin();}
	        }];
		}
		/*if (ServerObj.isNurseLogin=="1"){
			OrdToolBar.push({text:'处理医嘱',iconCls: 'icon-abort-order',handler: function() {ShowSeeOrderWin();}});
			OrdToolBar.push({text:'撤销处理',iconCls: 'icon-abort-order',handler: function() {ShowCancelSeeOrderWin();}})
		}*/
		var reg1=/<[^<>]+>/g;
		var reg2=/&nbsp/g;
		var OrdColumns=[[ 
		 			{field:'CheckOrd',title:'选择',checkbox:'true',align:'center',width:70,auto:false},
		 			{field:'TItemStatCode',hidden:true,title:''},
		 			{field:'TOeoriOeori',hidden:true,title:''},
		 			{field:'PHFreqDesc1',hidden:true,title:''},
		 			{field:'TPermission',hidden:true,title:''},
		 			{field:'TItemStatCode',hidden:true,title:''},
		 			{field:'TStDate',title:'医嘱开始时间',align:'center',width:140,auto:false},
		 			{field:'TOrderDesc',title:'医嘱',align:'left',width:450,auto:false,
		 				formatter: function(value,row,index){
			 				var inparaOrderDesc=$("#orderDesc").val();
			 				if (inparaOrderDesc!=""){
				 				var tmpvalue=value.replace(/\&nbsp;/g,"").replace(/\&nbsp/g,"");
								tmpvalue = tmpvalue.replace(inparaOrderDesc,"<font color=red>"+inparaOrderDesc+"</font>");
							}else{
								var tmpvalue=value;
							}
							var ordtitle=tmpvalue //.replace(reg1,'').replace(reg2,' ');
							var PopoverHtml=row['PopoverHtml'];
							return '<a class="editcls-TOrderDesc" id= "' + row["OrderId"] + '"onmouseover="ipdoc.patord.view.ShowOrderDescDetail(this)">'+ordtitle+'</a>';
							//return "<span title='" + ordtitle + "' class='hisui-tooltip'>" + value + "</span>";
		 				}
		 			},
		 			{field:'TDoctor',title:'开医嘱人',align:'center',width:80,auto:false},
		 			{field:'TStopDate',title:'停止时间',align:'center',width:140,auto:false,
		 				styler: function(value,row,index){
			 				if ((value!="")&&(value!=" ")){
				 				var stopDate=value.split(" ")[0];
				 				if (stopDate>ServerObj.CurrentDate){
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
		 			
		 			
		 			
		 	]]
		var InPatOrdProperty={
			fit : true,
			width:1500,
			border : false,
			striped : true,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : false,
			autoSizeColumn : false,
			rownumbers:true,
			idField:'OrderId',
			columns :OrdColumns,
			toolbar :OrdToolBar
		};
		if (ServerObj.OrderViewScrollView=="1"){
			$.extend(InPatOrdProperty,{
				pagination : false,
				view:scrollview,
				pageSize:20,	//每次初始化的条数
				ScrollView:1	//后台query接收，是否分页
			});
		}else{
			$.extend(InPatOrdProperty,{
				pagination : true,
				pageSize: 10,
				pageList : [10,100,200],
				ScrollView:0
			});
		}
		$.extend(InPatOrdProperty,{
			onClickRow:function(rowIndex, rowData){
			},
			rowStyler:function(rowIndex, rowData){
	 			if (rowData.ColorFlag=="1"){
		 			return 'color:#788080;';
		 		}else if((rowData.TOeoriOeori=="")&&(rowData.GroupSign!="")&&(rowData.NurseLinkOrderRowId=="")){
			 		return 'background-color:#60F807;';
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
					$('div.datagrid-toolbar a').eq(0).hide();
					$('div.datagrid-toolbar div').eq(0).hide();
					var startNum=4;
				}else if(ServerObj.PageShowFromWay=="ShowFromOrdCopy"){
					$('div.datagrid-toolbar a').eq(0).hide();
					$('div.datagrid-toolbar div').eq(0).hide();
					$('div.datagrid-toolbar div').eq(1).hide();
					//登录门诊访问住院的医嘱数据
					if ((ServerObj.LogonLocAdmTypeLimit=="N")&&(ServerObj.PAAdmType=="I")){
						$('div.datagrid-toolbar a').eq(1).hide();	//复制
						$('div.datagrid-toolbar a').eq(3).hide();	//复制为长期
						$('div.datagrid-toolbar a').eq(4).hide();	//复制为出院带药
					}
					$('div.datagrid-toolbar a').eq(6).hide();		//停止
					$('div.datagrid-toolbar a').eq(7).hide();		//撤销
					$('div.datagrid-toolbar a').eq(8).hide();		//作废
					var startNum=5;
					
				}else if(ServerObj.PageShowFromWay=="ShowFromEmrList"){
					$('div.datagrid-toolbar a').hide();
					$('.datagrid-toolbar').css('height', "1px");
					$('.datagrid-toolbar').css('padding', "0 2px");
					var startNum=5;
					$('.fixedh2-div').css('border-bottom', "0px dashed #ccc");
					$('.fixedh3-div').css('border-bottom', "0px dashed #ccc");
					$('.fixedh2-div ').css('border-top', "1px dashed #ccc");
				}else{
					$('div.datagrid-toolbar a').eq(6).hide();
				}
				
				var MenuAdm="";
				var frm = dhcsys_getmenuform();
			    if (frm) {
			    	MenuAdm = frm.EpisodeID.value;
			    }
			    //有可能是检索的其他就诊记录的医嘱进行的复制，按照menu上的就诊进行判断是否展示虚拟长期按钮
				if (MenuAdm!=ServerObj.EpisodeID){
					var UserEMVirtualtLong=$.cm({
					    ClassName : "web.DHCDocOrderVirtualLong",
					    MethodName : "GetUserEMVirtualtLong",
					    EpisodeID : MenuAdm
					},false);
					if (UserEMVirtualtLong=="0"){
						$('div.datagrid-toolbar a').eq(5).hide();
					}
				}else if (ServerObj.UserEMVirtualtLong=="0"){
					$('div.datagrid-toolbar a').eq(5).hide();		//复制为虚拟长期
				}
				if (ServerObj.patData.patFlag==0){
					for (var i=startNum;i<parseInt(startNum)+3;i++){
						$('div.datagrid-toolbar a').eq(i).hide();
						$('div.datagrid-toolbar div').eq(i).hide();
					}
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
			}
		});
		$.extend(InPatOrdProperty,{loadFilter:pagerFilter});
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
   	function LoadPatOrdDataGrid(SelOrdRowIDNext){
   		if (typeof SelOrdRowIDNext =="undefined"){SelOrdRowIDNext="";}
	   	//var myDate = new Date();
    	//var DateTime = myDate.toLocaleString() + '.' + myDate.getMilliseconds();
    	if (ServerObj.OrderViewScrollView=="1"){
	    	var pageSize=99999;
	    }else{
    		var pageSize=InPatOrdDataGrid.datagrid("options").pageSize;
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
		    OrderPriorType : GridParams.Arg11,
		    Pagerows:pageSize,
		    ScrollView:InPatOrdDataGrid.datagrid("options").ScrollView,
		    rows:99999
		},function(GridData){
			InPatOrdDataGrid.datagrid('unselectAll').datagrid('uncheckAll').datagrid('loadData',GridData);
			if (SelOrdRowIDNext!=""){
				SelNextDocOrd(SelOrdRowIDNext);
			}
			if (ServerObj.PageShowFromWay=="ShowFromOrdCopy"){
				if ($("#moreBtn").hasClass('expanded')){
					InPatOrdDataGrid.datagrid("resize");
				}else{
					toggleExecInfo("#moreBtn");
				}
		    }
		}));

		
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
			}
		});
		if (!data.originalRows){
			data.originalRows = (data.rows);
		}
		if ((opts.pagination)&&(data.originalRows.length>0)){
			var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
			/*
			目前发现删除最后一页所有数据之后，页码还是定位到最后一页，但是页码数已经被置到了前一页
			*/
			if ((start+1)>data.originalRows.length){
				//取现有行数最近的整页起始值
				start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
				//opts.pageNumber=opts.pageNumber-1;
				opts.pageNumber=(start/opts.pageSize)+1;
			}
			var end = start + parseInt(opts.pageSize);
			data.rows = (data.originalRows.slice(start, end));
		}
		return data;
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
			})
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
		 			{field:'TExecFreeRes',title:'免费原因',width:100},
		 			{field:'TExecUser',title:'处理人',width:80},
		 			{field:'TExecLoc',title:'处理科室',width:80},
		 			{field:'ExecPart',title:'检查部位',width:80},
		 			{field:'TBillState',title:'账单状态',width:80,
		 				formatter:function(value,rec){  
		                   var btn = '<a class="editcls" onclick="ipdoc.patord.view.execFeeDataShow(\'' + rec.OrderExecId + '\')">'+value+'</a>';
					       return btn;
                        }
		 			},
		 			{field:'TExecFreeChargeFlag',title:'免费状态',width:100},
		 			
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
			striped : true,
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
			InPatOrdExecDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
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
          if (ServerObj.OrdrightKeyMenuHidden=="true") return false;
	      if ((rowData.TPriorityCode=="S")||(rowData.TPriorityCode=="OMST")||(rowData.TPriorityCode=="OMCQZT")){
	         var RightMenu=eval("("+ServerObj.orderRightMenuJson+")");
	      }else{
	         var RightMenu=eval("("+ServerObj.orderSOSRightMenuJson+")");
	      }
	      GetOrdDealPermissionTitle();
	   }else if(type="OrdExec"){
		  InPatOrdExecDataGrid.datagrid("clearSelections"); 
	      InPatOrdExecDataGrid.datagrid("selectRow", rowIndex); 
	      if (ServerObj.ExecrightKeyMenuHidden=="true") return false;
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
	   //开医嘱人
	   var cbox = $HUI.combobox("#doctorList", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: eval("("+ServerObj.OrdDoctorList+")"),
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
		        $('#Ordlayout_main').layout('panel', 'center').panel('resize',{width:_width})
		        InPatOrdDataGrid.datagrid("resize");
	        }/*,
	        onExpand: function() {
		        var _width=$('#Ordlayout_main').layout('panel', 'center').panel('options').width;
		        $('#Ordlayout_main').layout('panel', 'center').panel('resize',{width:(_width-413)})
		        InPatOrdDataGrid.datagrid("resize");
	        }*/,
	        onResize: function() {
		        var eastWidth=$('#Ordlayout_main').layout('panel', 'east').panel('options').width;
		        var width=$(window).width()-eastWidth;
		        //病历浏览加载住院医嘱列表，页面左侧两侧不存在空白区域不需要减去20
		        if (ServerObj.PageShowFromWay!="ShowFromEmrList"){
			        width=width-20;
			    }
		        $('#Ordlayout_main').layout('panel', 'center').panel('resize',{width:width})
		        InPatOrdDataGrid.datagrid("resize");
	        }
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
		    return false;   
	    }
	}
   function OrdReSubCatList(){
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
			var ListJson=eval("("+ServerObj.OrdReSubCatListJson+")");
			GridParams.Arg9=ListJson[index-1].id;
			if ((ListJson[index-1].text==$g("检查"))||(ListJson[index-1].text==$g("检验"))){
				$HUI.radio("#OrderTypeOM").setValue(true);
				GridParams.Arg8="OM"
				}
		    LoadPatOrdDataGrid();
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
	   var iconCls="icon-w-edit";
	   createModalDialog("OrdDiag",title, 380, 280,iconCls,$g("停止"),Content,"MulOrdDealWithCom('S')");
	   InitStopMulOrdWin(SelOrdRowStr,OnlyOneGroupFlag);
	   $("#winPinNum").focus();
   }
   function ShowCancelMulOrdWin(){
	   if (!CheckIsCheckOrd()) return false;
	   //var FindLongOrd=0;
	   var SelOrdRowStr=GetSelOrdRowStr();
	   if (!CheckOrdDealPermission(SelOrdRowStr,"C")) return false;
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
	   var iconCls="icon-w-edit";
	   createModalDialog("OrdDiag",title, 380, 171,iconCls,$g("撤销(DC)"),Content,"MulOrdDealWithCom('C')");
	   InitOECStatusChReason();
	   $('#OECStatusChReason').next('span').find('input').focus();
	   //$("#winPinNum").focus();
   }
   function ShowUnUseMulOrdWin(){
	   if (!CheckIsCheckOrd()) return false;
	   var SelOrdRowStr=GetSelOrdRowStr();
	   if (!CheckOrdDealPermission(SelOrdRowStr,"U")) return false;
	   var title=$g("作废医嘱");
	   destroyDialog("OrdDiag");
	   var Content=initDiagDivHtml("U")
	   var iconCls="icon-w-edit";
	   createModalDialog("OrdDiag",title, 380, 171,iconCls,$g("作废"),Content,"MulOrdDealWithCom('U')");
	   InitOECStatusChReason();
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
	   createModalDialog("OrdDiag",title, 380, 230,iconCls,$g("确认"),Content,"MulOrdDealWithCom('NurSeeOrd')");
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
			   $.messager.alert("提示","停止日期不能为空!");
			   $('#winStopOrderDate').next('span').find('input').focus();
			   return false;
		   }
		   if(!DATE_FORMAT.test(date)){
			   $.messager.alert("提示","停止日期格式不正确!");
			   return false;
		   }
		   var time=$('#winStopOrderTime').timespinner('getValue'); //$('#winStopOrderTime').combobox('getText');
		   if (time==""){
			   $.messager.alert("提示","停止时间不能为空!");
			   $('#winStopOrderTime').next('span').find('input').focus();
			   return false;
		   }
		   if (!IsValidTime(time)){
			   $.messager.alert("提示","停止时间格式不正确! 时:分:秒,如11:05:01");
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
			   $.messager.alert("提示","要求执行时间不能为空!");
			   $('#winRunOrderTime').next('span').find('input').focus();
			   return false;
		   }
		   if (!IsValidTime(time)){
			   $.messager.$.messager.alert("提示","要求执行时间格式不正确! 时:分:秒,如11:05:01");
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
	   if ((type=="S")||(type=="C")||(type=="U")){
			if (ExeCASigin("")==false){
				return false;
			} 
	   }
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
			if ((type=="U")&&(alertCode=="-901")){
				$.messager.alert("提示",val.split("^")[1]);
				val="0";
				DischargeOEORI=val.split("^")[2];
			}
			if (alertCode=="0"){
				if ((type=="S")||(type=="C")||(type=="U")){             //2018-9-4 fxn ca签名
					ExeCASigin(SelOrdRowStr);  
				}
				if (type=="Addexec"){
					//增加执行医嘱后,需自动双击该医嘱
					/*if (ServerObj.isNurseLogin=="1"){
						var rowData=InPatOrdDataGrid.datagrid("getSelected");
						var rowIndex=InPatOrdDataGrid.datagrid("getRowIndex",rowData);
						OrdDataGridDbClick(rowIndex, rowData,0) 
					}*/
				}else{
					if (ServerObj.PageShowFromWay){
						InPatOrdDataGrid.datagrid("clearSelections");
		            	InPatOrdDataGrid.datagrid("clearChecked");
						LoadPatOrdDataGrid();
						SetVerifiedOrder(false);
					}else{
						InPatOrdDataGrid.datagrid('reload');
					}
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
				$.messager.alert("提示",alertCode);
				return false;
			}
		});
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
	   /*$.q({
		    ClassName : "web.DHCDocInPatPortalCommon",
		    QueryName : "GetPHFreqInfoList",
		    oeori : SelOrdRowStr.split("^")[0].split(String.fromCharCode(1))[0]
		},function(GridData){
			var cbox = $HUI.combobox("#winStopOrderTimes", {
				editable: false,
				multiple:false,
				mode:"local",
				method: "GET",
				selectOnNavigation:true,
			  	valueField:'id',
			  	textField:'text',
			  	data:GridData.rows,
				onSelect: function (record) {
					var sbox = $HUI.timespinner("#winStopOrderTime");
					//sbox.setValue(record.id+":10");
					sbox.setValue(record.seltext);
					$("#winPinNum").focus();
			    }
			});
		});*/
	    /*var cbox = $HUI.combobox("#winStopOrderTime", {
			editable: true,
			multiple:false,
			mode:"local",
			method: "GET",
			selectOnNavigation:true,
		  	valueField:'id',
		  	textField:'text',
		  	data:eval("("+ServerObj.IntervalTimeListJson+")")
		});
	   cbox.setValue(GetCurTime());*/
	   $("#winStopOrderTime").timespinner('setValue',GetCurTime());
	   $HUI.checkbox("#isExpStopOrderCB",{
		   onChecked:function(event,value){
			    $("#winStopOrderDate").datebox({ disabled:false});
				$("#winStopOrderDate").datebox("setValue",ServerObj.NextDate);
				//$("#winStopOrderTimes").combobox({ disabled:false});
				LoadwinStopOrderTimes(FirstOrdRowid,ServerObj.NextDate);
				$("#winStopOrderTime").timespinner('setValue',GetCurTime());
	   		},
	   		onUnchecked:function(){
			    $("#winStopOrderDate").datebox({ disabled:true})
			   	$("#winStopOrderDate").datebox("setValue",ServerObj.CurrentDate);
			   	//$("#winStopOrderTimes").combobox({ disabled:true})
			   	LoadwinStopOrderTimes(FirstOrdRowid,ServerObj.CurrentDate);
			   	$("#winStopOrderTime").timespinner('setValue',GetCurTime());
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
   function initDiagDivHtml(type){
	   if (type=="S"){
		   var html="<div id='DiagWin' style=''>"
			   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("是否预停")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input class='hisui-checkbox' type='checkbox' id='isExpStopOrderCB'/>"
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("停止日期")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='winStopOrderDate' disabled='false' class='hisui-datebox textbox' required='required'></input>"
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("停止时间")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='winStopOrderTime' class='hisui-timespinner textbox' data-options='showSeconds:true'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("执行次数")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='winStopOrderTimes'  editable='false' class='textbox'></input>" //disabled='false'
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("密码")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input type='password' id='winPinNum' style='' class='hisui-validatebox textbox' data-options='required:true' onkeydown='ipdoc.patord.view.DiagDivKeyDownHandle(\"Confirm\",\""+type+"\")' /> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			   html +="	</table>"
		   html += "</div>"
	   }else if((type=="C")||(type=="U")){
		   var html="<div id='DiagWin' style='margin-top: 5px;'>"
			   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
			   		html +="	 <tr>"
				       	html +="	 <td class='r-label'>"
				       		html +="	 "+$g("作废/撤销原因")
				       	html +="	 </td>"
				       	html +="	 <td>"
				       		html +="	 <input id='OECStatusChReason' class='textbox'></input>"
				       	html +="	 </td>"
			        html +="	 </tr>"
			       
			   		html +="	 <tr>"
			       		html +="	 <td class='r-label'>"
			       			html +="	 "+$g("密码")
			       		html +="	 </td>"
			       		html +="	 <td>"
			       			html +="	 <input type='password' id='winPinNum' class='hisui-validatebox textbox' data-options='required:true' onkeydown='ipdoc.patord.view.DiagDivKeyDownHandle(\"Confirm\",\""+type+"\")' />"
			       		html +="	 </td>"
			       	html +="	 </tr>"
			       	
			   html +="	</table>"
		   html += "</div>"
	   }else if(type=="A"){
		   var html="<div id='DiagWin' style='margin-top: 5px;'>"
			   html +="	 <div style='margin:0 auto;border:none;'>" 
			   		html += "  <textarea style='width:364px;height:128px;margin:5px;' class='' data-options='required:true' id='OrderNotes'></textarea>"
			   html += " </div>"
		   html += "</div>"
	   }else if(type=="NurA"){
		   var html="<div id='DiagWin' style='margin-top: 5px;'>"
			   html +="	 <div style='margin:0 auto;border:none;'>" 
			   		html += "  <textarea rows=7 style='width:96%;margin:5px;' data-options='required:true' id='OrderExecNotes'></textarea>"
			   html += " </div>"
		   html += "</div>"
	   }else if((type=="NurC")||(type=="NurS")){
		   var html="<div id='DiagWin' style=''>"
			   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("作废/撤销原因")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='OECStatusChReason' class='textbox'></input>"
			       	html +="	 </td>"
			       html +="	 </tr>"
			   html +="	</table>"
		   html += "</div>"
	   }else if((type=="NurR")||(type=="AddExec")){
		   var label1=$g("执行日期:"),label2=$g("执行时间")
		   if (type=="AddExec") {
			   label1=$g("要求")+label1;
			   label2=$g("要求")+label2;
		   }
		   var html="<div id='DiagWin' style=''>"
			   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g(label1)
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='winRunOrderDate' type='text' class='hisui-datebox' required='required'></input>"
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g(label2)
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='winRunOrderTime' class='hisui-combobox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 </tr>"
			       
			   html +="	</table>"
		   html += "</div>"
	   }else if(type=="NurUpdateEndTime"){
		   var html="<div id='DiagWin' style=''>"
			   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("结束时间")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='winHourEndTime' class='hisui-combobox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 </tr>"
			       
			   html +="	</table>"
		   html += "</div>"
	   }else if (type=="NurSeeOrd"){
		   var html="<div id='DiagWin' style=''>"
			   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("类型")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdType' class='textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("日期")
			       	html +="	 </td>"
			       	html +="	 <td class='r-label' class='r-label'>"
			       		html +="	 <input id='SeeOrdDate' class='hisui-datebox textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("时间")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdTime' class='hisui-timespinner textbox' data-options='showSeconds:true'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("备注")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdNotes' class='textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			   html +="	</table>"
		   html += "</div>"
	   }else if (type=="NurCancelSeeOrd"){
		   var html="<div id='DiagWin' style=''>"
			   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
			     html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("日期")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdDate' class='hisui-datebox textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("时间")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdTime' class='textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("备注")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdNotes' class='textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"  
			   html +="	</table>"
		   html += "</div>"
	   }else if(type=="CancelPreStopOrd"){
		   var html="<div id='DiagWin' style='margin-top: 5px;'>"
			   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
			   		html +="	 <tr>"
			       		html +="	 <td class='r-label'>"
			       			html +="	 "+$g("密码")
			       		html +="	 </td>"
			       		html +="	 <td>"
			       			html +="	 <input type='password' id='winPinNum' class='hisui-validatebox textbox' data-options='required:true' onkeydown='ipdoc.patord.view.DiagDivKeyDownHandle(\"Confirm\",\""+type+"\")'/>"
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
			iconCls:'icon-w-close',
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
   }
   function myformatter(date){
		var y = date.getFullYear();
		var m = date.getMonth()+1;
		var d = date.getDate();
		if (ServerObj.DateFormat==3){
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		}else if(DateFormat==4){
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
	    createModalDialog("OrdDiag","增加备注", 380, 240,iconCls,"增加备注",Content,"MulOrdDealWithCom('A')");
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
		var patDataObj=eval("("+ServerObj.patData+")");
		if (patDataObj.patFlag>0){
			title=$g("病人已")+patDataObj.flagDesc+"!";
		}
		return title;
	}
	function surgeryApplyHandler(){ //dhcclinic.anop.app.csp
		//window.showModalDialog("dhcanoperapplication.csp?opaId=&appType=ward&EpisodeID="+ServerObj.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:1250px;resizable:yes");	
		websys_showModal({
			url:"dhcanoperapplication.csp?opaId=&appType=ward&EpisodeID="+ServerObj.EpisodeID,
			title:'手术申请',
			width:'90%',height:'90%',
			CallBackFunc:function(CallBackData){
				LoadPatOrdDataGrid();
			}
		})
	}
	function surgeryApplyShowHandler(){
		var title="";
		var patDataObj=eval("("+ServerObj.patData+")");
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
			width:screen.availWidth-200,height:screen.availHeight-200
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
		return title;
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
			title:'修改不规则医嘱单次剂量',
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
	    createModalDialog("OrdDiag","增加备注", 380, 240,iconCls,"增加备注",Content,"MulOrdDealWithCom('A')");
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
		  	data:eval("("+ServerObj.OECStatusChReasonJson+")")
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
			striped : true,
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
			InPatExecFeeDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
		});
	}
	function ordDetailInfoShow(OrdRowID){
		websys_showModal({
			url:"dhc.orderdetailview.csp?ord=" + OrdRowID,
			title:'医嘱明细',
			width:400,height:screen.availHeight-200
		});
	}
	function OpenOrderView(OEItemID){
		//$.orderview.show(OEItemID);
		websys_showModal({
			url:"dhc.orderview.csp?ord=" + OEItemID,
			title:'医嘱查看',
			width:screen.availWidth-200,height:screen.availHeight-200
		});
		
	}
	/**********end***************/
	function ReLoadGridDataFromOrdEntry(OrderPrior,SelOrdRowIDNext){
		InPatOrdDataGrid.datagrid("resize");
		if ((OrderPrior == "ShortOrderPrior") || (OrderPrior == "OutOrderPrior"))  {
			var o=$HUI.radio("#OrderTypeOM");
			GridParams.Arg8="OM";
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
		if (OrderPrior=="OutOrderPrior"){
			GridParams.Arg11=OrderPrior;
		}else{
			GridParams.Arg11="";
		}
		o.jdata.options.onChecked=o.jdata.options.stateonChecked;
		LoadPatOrdDataGrid(SelOrdRowIDNext);
		GridParams.Arg11=""; //控制只有医嘱录入界面点击“出院带药”时，临时医嘱单只显示“出院带药”，否则显示临时医嘱+出院带药
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
		if ($(ele).hasClass('expanded')){  //已经展开 隐藏
			$(ele).removeClass('expanded');
			$("#moreBtn")[0].innerText=$g("更多");
	    	$("#more").hide(); //#dashline
	    	setHeight("-39");
		}else{
			$(ele).addClass('expanded');
			$("#moreBtn")[0].innerText=$g("隐藏");
	    	$("#more").show(); //#dashline
	    	setHeight('39');
		}
		function setHeight(num){
			var p=$("#OrdSearch-div > .layout-panel-north:first");
			var Height=parseInt(p.outerHeight())+parseInt(num);
			p.css({height:Height});
			
			//怎么有效防止强制同步布局
			var p = $("#OrdSearch-div > .layout-panel-center:first");	// get the center panel
			var Height = parseInt(p.outerHeight())-parseInt(num);
			if (ServerObj.PageShowFromWay=="ShowFromEmr"){
				if (+num>0) p.css({top:124,height:Height});
				else p.css({top:84,height:Height});
			}else{
				if (+num>0) p.css({top:84,height:Height});
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
	    }
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
		EpisPatObj.PatAdmInfoJson=EpisPatObj.PatAdmInfoJson?EpisPatObj.PatAdmInfoJson.replace(/\\{2,}/g,"\\"):"";
		EpisPatObj.OrdDoctorList=EpisPatObj.OrdDoctorList?EpisPatObj.OrdDoctorList.replace(/\\{2,}/g,"\\"):"";
		EpisPatObj.patData=EpisPatObj.patData?EpisPatObj.patData.replace(/\\{2,}/g,"\\"):"";
		EpisPatObj.EmrQualityQtyJson=EpisPatObj.EmrQualityQtyJson?EpisPatObj.EmrQualityQtyJson.replace(/\\{2,}/g,"\\"):"";
		EpisPatObj.MessageMarquee=EpisPatObj.MessageMarquee?EpisPatObj.MessageMarquee.replace(/\\{2,}/g,"\\"):"";
		
		$.extend(ServerObj,EpisPatObj);
		
		var doctorListData=eval("("+ServerObj.OrdDoctorList+")");
		$.extend(GridParams,{
			"Arg1":ServerObj.PatientID,
			"Arg2":ServerObj.EpisodeID,
			"Arg3":doctorListData[0].id
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
		var doctorListData=eval("("+ServerObj.OrdDoctorList+")")
		$HUI.combobox("#doctorList", {
			data: doctorListData,
		});
		$("#MessageMarquee").html(ServerObj.MessageMarquee);
		
		if (InPatOrdDataGrid){InPatOrdDataGrid.datagrid('unselectAll').datagrid('uncheckAll');}
		if (typeof InPatOrdExecDataGrid !="undefined"){
			InPatOrdExecDataGrid.datagrid("unselectAll").datagrid('loadData',[]);
			$('#Ordlayout_main').layout('panel', 'east').panel('setTitle',"");
		}
		//防止部分浏览器局部刷新时页面显示空白
		ForceRefreshLayout();
		//关闭所有的dialog,window,message
		$(".panel-body.window-body").each(function(index,element){
			$(element).window("destroy");
		});
		InPatOrdDataGridLoadSuccCallBack.add(CallBackFunc);
		/*
		///tanjishan 2019-07-08屏蔽，汪工已修正短时间内调用多次xrh方法的bug，不会再出现onloadsuccess不调用的问题
		if (CallBackFunc) {
			InPatOrdDataGridLoadSuccCallBack.CallBackFunc=CallBackFunc();
		}
		*/
		LoadPatOrdDataGrid("");
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
	   "getRefData":getRefData
   }
})();
