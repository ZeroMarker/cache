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
		//��ʼ�������������
		InitPatOrderViewGlobal(EpisPatInfo);
		
		//��ʼ��סԺ����ҽ����Ϣ���
		//var InPatOrdDataGrid;
		//var InPatOrdExecDataGrid;
		var DefaultScopeDesc=GetArrayDefaultData(ServerObj.ViewScopeDescData);
		var DefaultOrderSort=GetArrayDefaultData(ServerObj.ViewOrderSortData);
		var DefaultLocDesc=GetArrayDefaultData(ServerObj.ViewLocDescData);
		var DefaultNurderBill=GetArrayDefaultData(ServerObj.ViewNurderBillData);
		var GridParams={
	        "Arg1":ServerObj.PatientID,"Arg2":ServerObj.EpisodeID,"Arg3":$g("ȫ��")
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
			var content=$(that).html(); //��֤������������ʽ��������Ҳ����
		}*/
		var OrderRowId=that.id;
		var index=InPatOrdDataGrid.datagrid('getRowIndex',OrderRowId);
		if (ServerObj.OrderViewScrollView=="1"){
			var rows = InPatOrdDataGrid.datagrid('getData').originalRows;
        }else{
        	var rows = InPatOrdDataGrid.datagrid('getRows');
		}
		var content=rows[index]['PopoverHtml'];
		var contentFlag=content.split("@")[0]; //Ϊ0 ������ʾ����ҽ������Ϣ Ϊ1�������۳��ȶ�Ҫ��ʾ
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
	            text: '��ҽ��',
	            iconCls: 'icon-write-order',
	            handler: function() {
		            if (typeof parent.switchTabByEMR =="function"){
						//parent.switchTabByEMR("dhc_side_oe_oerecord");
						parent.switchTabByEMR($g("ҽ��¼��"));
					}
		        }
	        },'-',{
	            text: '����',
	            iconCls: 'icon-copy',
	            handler: function() {copyOrderHandler(""); }
	        },{
	            text: '����Ϊ��ʱ',
	            iconCls: 'icon-copy-sos',
	            handler: function() {copyOrderHandler("NORM"); }
	        },{
	            text: '����Ϊ����',
	            iconCls: 'icon-copy-prn',
	            handler: function() {copyOrderHandler("S");}
	        },{
	            text: '����Ϊ��Ժ��ҩ',
	            iconCls: 'icon-copy-drug',
	            handler: function() { copyOrderHandler("OUT");}
	        },{
	            text: '����Ϊ���ⳤ��',
	            iconCls: 'icon-copy-prn',
	            handler: function() { copyOrderHandler("VirLong");}
	        },'-', {
	            text: 'ͣҽ��',
	            iconCls: 'icon-stop-order',
	            handler: function() {ShowStopMulOrdWin();}
	        },{
	            text: '����',
	            iconCls: 'icon-cancel-order',
	            handler: function() {ShowCancelMulOrdWin();}
	        },{
	            text: '����',
	            iconCls: 'icon-abort-order',
	            handler: function() {ShowUnUseMulOrdWin();}
	        }];
		}
		/*if (ServerObj.isNurseLogin=="1"){
			OrdToolBar.push({text:'����ҽ��',iconCls: 'icon-abort-order',handler: function() {ShowSeeOrderWin();}});
			OrdToolBar.push({text:'��������',iconCls: 'icon-abort-order',handler: function() {ShowCancelSeeOrderWin();}})
		}*/
		var reg1=/<[^<>]+>/g;
		var reg2=/&nbsp/g;
		var OrdColumns=[[ 
		 			{field:'CheckOrd',title:'ѡ��',checkbox:'true',align:'center',width:70,auto:false},
		 			{field:'TItemStatCode',hidden:true,title:''},
		 			{field:'TOeoriOeori',hidden:true,title:''},
		 			{field:'PHFreqDesc1',hidden:true,title:''},
		 			{field:'TPermission',hidden:true,title:''},
		 			{field:'TItemStatCode',hidden:true,title:''},
		 			{field:'TStDate',title:'ҽ����ʼʱ��',align:'center',width:140,auto:false},
		 			{field:'TOrderDesc',title:'ҽ��',align:'left',width:450,auto:false,
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
		 			{field:'TDoctor',title:'��ҽ����',align:'center',width:80,auto:false},
		 			{field:'TStopDate',title:'ֹͣʱ��',align:'center',width:140,auto:false,
		 				styler: function(value,row,index){
			 				if ((value!="")&&(value!=" ")){
				 				var stopDate=value.split(" ")[0];
				 				if (stopDate>ServerObj.CurrentDate){
					 				return 'background-color:yellow';
					 			}
				 			}
			 			}
		 			},
		 			{field:'TStopDoctor',title:'ֹͣҽ��',align:'center',width:80,auto:false},
		 			{field:'TStopNurse',title:'ֹͣ����ʿ',align:'center',width:90,auto:false},
		 			{field:'TItemStatDesc',title:'״̬',align:'center',width:80,auto:false,
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
		 			{field:'TdeptDesc',title:'��������',align:'center',width:120,auto:false},
		 			{field:'TRecDepDesc',title:'���տ���',align:'center',width:120,auto:false},
		 			{field:'Priority',title:'ҽ������',align:'center',width:80,auto:false},
		 			{field:'OrderType',title:'ҽ����������',align:'center',width:60,auto:false},
		 			{field:'TBillUom',title:'�Ƽ۵�λ',align:'center',width:80,auto:false},
		 			{field:'GroupSign',title:'�����',align:'center',width:30,auto:false,
		 			 styler: function(value,row,index){
			 			 return 'color:red;';
		 			 }
		 			},
		 			{field:'OrderId',title:'ҽ��ID',align:'center',width:120,auto:false,
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
		 			{field:'TOEORIAddDate',title:'��ҽ������',align:'center',width:145,auto:false},
		 			{field:'TOEORISeeInfo',title:'��ʿ����״̬',align:'center',width:145,auto:false},
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
				pageSize:20,	//ÿ�γ�ʼ��������
				ScrollView:1	//��̨query���գ��Ƿ��ҳ
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
					//��ʿ��¼ģʽ�£�ǿ���ߵ�ѡģʽ
					var SelRowList=InPatOrdDataGrid.datagrid('getSelections').slice();
					///����ǿ�Ʋ�����uncheck�¼�����ֹ��ε���ҽ��¼�뷽��
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
				//��ѡ��ҽ��
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
				}else if (TOeoriOeori.indexOf("||")>=0){ //��ѡ��ҽ�� ���ڿ��е����
					var MasterrowIndex=InPatOrdDataGrid.datagrid('getRowIndex',TOeoriOeori);
					if (MasterrowIndex>=0){
						InPatOrdDataGrid.datagrid('checkRow',MasterrowIndex);
					}
				}else if (NurseLinkOrderRowId.indexOf("||")>=0){ //��ѡ������ҽ��
					var MasterrowIndex=InPatOrdDataGrid.datagrid('getRowIndex',NurseLinkOrderRowId);
					if (MasterrowIndex>=0){
						InPatOrdDataGrid.datagrid('checkRow',MasterrowIndex);
					}
				}
				selRowIndex="";
				/*
				�����onselectrow������oncheck��Դ��bug���ȴ���onCheck��Ȼ����
				�ı�������Ϊselect״̬������Ҫʹ��settimeout�����¼��Ƶ���ջ���֤
				ִ��˳��
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
				//��ѡ��ҽ��
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
				}else if (TOeoriOeori!=""){ //��ѡ��ҽ��
					var MasterrowIndex=InPatOrdDataGrid.datagrid('getRowIndex',TOeoriOeori);
					if (MasterrowIndex>=0){
						InPatOrdDataGrid.datagrid('uncheckRow',MasterrowIndex);
					}
				}else if (NurseLinkOrderRowId.indexOf("||")>=0){ //��ѡ������ҽ��
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
					//��¼�������סԺ��ҽ������
					if ((ServerObj.LogonLocAdmTypeLimit=="N")&&(ServerObj.PAAdmType=="I")){
						$('div.datagrid-toolbar a').eq(1).hide();	//����
						$('div.datagrid-toolbar a').eq(3).hide();	//����Ϊ����
						$('div.datagrid-toolbar a').eq(4).hide();	//����Ϊ��Ժ��ҩ
					}
					$('div.datagrid-toolbar a').eq(6).hide();		//ֹͣ
					$('div.datagrid-toolbar a').eq(7).hide();		//����
					$('div.datagrid-toolbar a').eq(8).hide();		//����
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
			    //�п����Ǽ��������������¼��ҽ�����еĸ��ƣ�����menu�ϵľ�������ж��Ƿ�չʾ���ⳤ�ڰ�ť
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
					$('div.datagrid-toolbar a').eq(5).hide();		//����Ϊ���ⳤ��
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
				///tanjishan 2019-07-08���Σ�������������ʱ���ڵ��ö��xrh������bug�������ٳ���onloadsuccess�����õ�����
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
					                    ///�����ϲ�����ѭ��������
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
						                    ///�����ϲ�����ѭ��������
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
				dg.datagrid('scrollTo',0); //������ָ������        
				/*
				ˢ�µ�ǰҳ��ѡ����,Դ�����������ӳ٣�Ҫ��֤��ջִ��˳��
				����ҲҪ��
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
			Ŀǰ����ɾ�����һҳ��������֮��ҳ�뻹�Ƕ�λ�����һҳ������ҳ�����Ѿ����õ���ǰһҳ
			*/
			if ((start+1)>data.originalRows.length){
				//ȡ���������������ҳ��ʼֵ
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
	///��¼ģʽ�£���ҽ��¼������
	function SetVerifiedOrder(unCheckFlag){
		var SelRowListRowData=InPatOrdDataGrid.datagrid('getSelections');
		var SelRowList=[];
		var NeedUnCheckRowList=[];
		///ɾ���Ǳ�ҳ������
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

		///ȡ���һ������ҽ��
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
		//�Զ�ѡ����һ��ҽ��
		var par_win=GetOrdPatWin();
		if (!par_win){return false;}
		if (typeof par_win.SetVerifiedOrder != "function"){return false;}
		
		var ListData = InPatOrdDataGrid.datagrid('getData');
		var i = 0;
		var opts = InPatOrdDataGrid.datagrid('options');
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);
		/*������һ��*/
		var NextRowIndex="";
		var FindCurrSel=0;
		/*��Ҫ��ҳ��ҳ��*/
		var ScorllPageNum=0;
		for (i=0;i<ListData.originalRows.length;i++){
			//�ӱ���ҽ��������
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
			/*û�ҵ��������,���ѡ�� par_win.SetVerifiedOrder("");*/
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
	        //��֤˫�����Ҽ�ʱֻѡ����һ��,��Ҫ��Գ���ҽ��
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
			//˫��ҽ��,չʾִ�м�¼��Ϣ
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
		 			{field:'CheckOrdExec',title:'ѡ��',checkbox:'true'},
		 			{field:'OrderExecId',hidden:true},
		 			{field:'TExStDate',title:'Ҫ��ִ��ʱ��',width:110},
		 			{field:'TRealExecDate',title:'ִ��ʱ��',width:110},
		 			{field:'TExecState',title:'״̬',width:80,
		 				styler: function(value,row,index){
			 				if (row.TExecStateCode){
				 				if( ["δִ��","D","C"].indexOf(row.TExecStateCode) > -1 ){
					 				return "background-color: yellow;"
					 			}
			 				}
			 			}
		 			},
		 			{field:'THourExEnTime',title:'Сʱҽ������ʱ��',width:130},
		 			{field:'OrdExecBillQty',title:'�Ʒ�����',width:80},
		 			{field:'TExecRes',title:'ִ��ԭ��',width:100},
		 			{field:'TExecFreeRes',title:'���ԭ��',width:100},
		 			{field:'TExecUser',title:'������',width:80},
		 			{field:'TExecLoc',title:'�������',width:80},
		 			{field:'ExecPart',title:'��鲿λ',width:80},
		 			{field:'TBillState',title:'�˵�״̬',width:80,
		 				formatter:function(value,rec){  
		                   var btn = '<a class="editcls" onclick="ipdoc.patord.view.execFeeDataShow(\'' + rec.OrderExecId + '\')">'+value+'</a>';
					       return btn;
                        }
		 			},
		 			{field:'TExecFreeChargeFlag',title:'���״̬',width:100},
		 			
		 			{field:'TgiveDrugQty',title:'��ҩ����',width:80},
		 			{field:'TcancelDrugQty',title:'��ҩ����',hidden:true,width:80},
		 			{field:'Notes',title:'��ע',width:100},
		 			{field:'TPBOID',title:'�˵���',width:80},
		 			{field:'TApplyCancelStatus',hidden:true},
		 			{field:'TExDateTimes',hidden:true},
		 			{field:'IsCancelArrivedOrd',hidden:true},
		 			{field:'TExecStateCode',hidden:true},
		 			{field:'TPriorityCode',title:'ҽ������code',hidden:true},
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
	   e.preventDefault(); //��ֹ����������Ҽ��¼�
	   $("#RightKeyMenu").empty(); //	������еĲ˵�
	   if (type=="Ord"){
          InPatOrdDataGrid.datagrid("clearChecked");
          selRowIndex=rowIndex; //��֤�Ҽ�ʱֻѡ����һ��,�Գ���Ҳ�����
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
	        left: e.pageX,         //�����������ʾ�˵�
	        top: e.pageY
	    });
	   
   }
   function InitPageItemEvent(){
	   //��ҽ����
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
		   //ҽ������
		   var OrdReSubCatListJson=eval("("+ServerObj.OrdReSubCatListJson+")");
		   OrdReSubCatListJson.splice(1, 0, {"id":"ALLNotDurg","text":$g("ȫ����ҩƷ")});
		   OrdReSubCatListJson.splice(2, 0, {"id":"ALLLabAndService","text":$g("ȫ��������")});
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
	   //����
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
	   //��������
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
	  //ҽ������
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
		        //�����������סԺҽ���б�ҳ��������಻���ڿհ�������Ҫ��ȥ20
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
	   //�������Backspace������  
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
			if ((ListJson[index-1].text==$g("���"))||(ListJson[index-1].text==$g("����"))){
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
		   $.messager.alert("��ʾ","��ѡ����Ҫ���Ƶ�ҽ��!");
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
		   $.messager.alert("��ʾ","��ѡ����Ҫ���Ƶ�ҽ��!");
		   return false;
	   }
	   oeoris=oeoris.split("^").sort(function(num1,num2){
	       return parseFloat(num1.split("||")[1])-parseFloat(num2.split("||")[1]);
	   }).join("^");
	   if (typeof parent.switchTabByEMR =="function"){ //dhc_side_oe_oerecord
		   parent.switchTabByEMR($g("ҽ��¼��"),{oneTimeValueExp:"copyOeoris="+oeoris+"&copyTo="+priorCode});
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
		   $.messager.alert("��ʾ",rtn);
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
	   var title=$g("ͣҽ��");
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
	   createModalDialog("OrdDiag",title, 380, 280,iconCls,$g("ֹͣ"),Content,"MulOrdDealWithCom('S')");
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
		   if (RowData["Priority"].indexOf("����")>=0){
			   FindLongOrd=1;
			   return;
		   }
	   });
	   if (FindLongOrd=="1"){
		   $.messager.alert("��ʾ","��ѡ��ҽ�����г���ҽ��,���ܽ��С�����������,����ѡѡ��!");
		   return false;
	   }*/
	   var title=$g("����(DC)ҽ��");
	   destroyDialog("OrdDiag");
	   var Content=initDiagDivHtml("C");
	   var iconCls="icon-w-edit";
	   createModalDialog("OrdDiag",title, 380, 171,iconCls,$g("����(DC)"),Content,"MulOrdDealWithCom('C')");
	   InitOECStatusChReason();
	   $('#OECStatusChReason').next('span').find('input').focus();
	   //$("#winPinNum").focus();
   }
   function ShowUnUseMulOrdWin(){
	   if (!CheckIsCheckOrd()) return false;
	   var SelOrdRowStr=GetSelOrdRowStr();
	   if (!CheckOrdDealPermission(SelOrdRowStr,"U")) return false;
	   var title=$g("����ҽ��");
	   destroyDialog("OrdDiag");
	   var Content=initDiagDivHtml("U")
	   var iconCls="icon-w-edit";
	   createModalDialog("OrdDiag",title, 380, 171,iconCls,$g("����"),Content,"MulOrdDealWithCom('U')");
	   InitOECStatusChReason();
	   $('#OECStatusChReason').next('span').find('input').focus();
	   //$("#winPinNum").focus();
   }
   //����ҽ��
   function ShowSeeOrderWin(){
	   if (!CheckIsCheckOrd()) return false;
	   var title=$g("����ҽ��");
	   destroyDialog("OrdDiag");
	   var Content=initDiagDivHtml("NurSeeOrd")
	   var iconCls="icon-w-edit";
	   createModalDialog("OrdDiag",title, 380, 230,iconCls,$g("ȷ��"),Content,"MulOrdDealWithCom('NurSeeOrd')");
	   //����
	   var cbox = $HUI.combobox("#SeeOrdType", {
		    editable: false,
			valueField: 'id',
			textField: 'text',
			editable:false, 
			data: [
			  {"id":"A","text":"����","selected":true}
			 ,{"id":"R","text":"�ܾ�"}
			 ,{"id":"F","text":"���"}
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
   //��������
   function ShowCancelSeeOrderWin(){
	   if (!CheckIsCheckOrd()) return false;
	   MulOrdDealWithCom('NurCancelSeeOrd');
   }
   //ҽ������������,��type���ֲ�ͬ����
   function MulOrdDealWithCom(type){
	   /*
	   type���˵��
	   ---����ҽ��
	   S:ֹͣ
	   C:����ҽ��
	   U:����ҽ��
	   NurSeeOrd:ҽ������
	   NurCancelSeeOrd:����ҽ������
	   Addexec:����ִ��ҽ��
	   CancelPreStopOrd:����Ԥͣ
	   ---����ִ�м�¼
	   NurR:ִ��
	   NurS:ִֹͣ��
	   NurC:����ִ��
	   NurUpdateEndTime:�޸�Сʱҽ������ʱ��
	   NurA:���ӱ�ע
	   */
	   var date="",time="";
	   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
	   var pinNum="";
	   if (type=="S"){
		   var date = $('#winStopOrderDate').datebox('getValue');
		   if (date==""){
			   $.messager.alert("��ʾ","ֹͣ���ڲ���Ϊ��!");
			   $('#winStopOrderDate').next('span').find('input').focus();
			   return false;
		   }
		   if(!DATE_FORMAT.test(date)){
			   $.messager.alert("��ʾ","ֹͣ���ڸ�ʽ����ȷ!");
			   return false;
		   }
		   var time=$('#winStopOrderTime').timespinner('getValue'); //$('#winStopOrderTime').combobox('getText');
		   if (time==""){
			   $.messager.alert("��ʾ","ֹͣʱ�䲻��Ϊ��!");
			   $('#winStopOrderTime').next('span').find('input').focus();
			   return false;
		   }
		   if (!IsValidTime(time)){
			   $.messager.alert("��ʾ","ֹͣʱ���ʽ����ȷ! ʱ:��:��,��11:05:01");
			   return false;
		   }
	   }else if(type=="Addexec"){
		   var date = $('#winRunOrderDate').datebox('getValue');
		   if (date==""){
			   $.messager.alert("��ʾ","Ҫ��ִ�����ڲ���Ϊ��!");
			   $('#winRunOrderDate').next('span').find('input').focus();
			   return false;
		   }
		   if(!DATE_FORMAT.test(date)){
			   $.messager.alert("��ʾ","Ҫ��ִ�����ڸ�ʽ����ȷ!");
			   return false;
		   }
		   var time=$('#winRunOrderTime').combobox('getText');
		   if (time==""){
			   $.messager.alert("��ʾ","Ҫ��ִ��ʱ�䲻��Ϊ��!");
			   $('#winRunOrderTime').next('span').find('input').focus();
			   return false;
		   }
		   if (!IsValidTime(time)){
			   $.messager.$.messager.alert("��ʾ","Ҫ��ִ��ʱ���ʽ����ȷ! ʱ:��:��,��11:05:01");
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
			   $.messager.alert("��ʾ","��ѡ�������дԭ��!","info",function(){
				   $('#OECStatusChReason').next('span').find('input').focus();
			   });
			   return false;
		   }
		   if ((Reasoncomment!="")&&(Reasoncomment.indexOf("^")>=0)){
				$.messager.alert("��ʾ","����ԭ��ָ���^��ϵͳ��������,���������������!",function(){
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
			   $.messager.alert("��ʾ","���벻��Ϊ��!","info",function(){
				   $("#winPinNum").focus();
			   });
			   return false;
		   }
	   }
	   if ((type=="NurSeeOrd")){
		   var SeeOrdType=$("#SeeOrdType").combobox('getValue');
		   var SeeOrdDate=$('#SeeOrdDate').datebox('getValue');
		   if (SeeOrdDate==""){
			   $.messager.alert("��ʾ","���ڲ���Ϊ��!","info",function(){
				   $('#SeeOrdDate').next('span').find('input').focus();
			   });
			   return false;
		   }
		   if(!DATE_FORMAT.test(SeeOrdDate)){
			   $.messager.alert("��ʾ","���ڸ�ʽ����ȷ!");
			   return false;
		   }
		   var SeeOrdTime=$('#SeeOrdTime').timespinner('getValue');//$('#SeeOrdTime').combobox('getText');
		   if (SeeOrdTime==""){
			   $.messager.alert("��ʾ","ʱ�䲻��Ϊ��!");
			   $('#SeeOrdTime').next('span').find('input').focus();
			   return false;
		   }
		   if (!IsValidTime(SeeOrdTime)){
			   $.messager.alert("��ʾ","ʱ���ʽ����ȷ! ʱ:��:��,��11:05:01");
			   return false;
		   }
		   var SeeOrdNotes=$("#SeeOrdNotes").val();
		   if ((SeeOrdNotes!="")&&(SeeOrdNotes.indexOf("^")>=0)){
				$.messager.alert("��ʾ","��ע�ָ���^��ϵͳ��������,���������������!",function(){
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
				$.messager.alert("��ʾ",val.split("^")[1]);
				val="0";
				DischargeOEORI=val.split("^")[2];
			}
			if (alertCode=="0"){
				if ((type=="S")||(type=="C")||(type=="U")){             //2018-9-4 fxn caǩ��
					ExeCASigin(SelOrdRowStr);  
				}
				if (type=="Addexec"){
					//����ִ��ҽ����,���Զ�˫����ҽ��
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
				$.messager.alert("��ʾ",alertCode);
				return false;
			}
		});
   }
   function IsValidDate(DateStr){ 
      //todo ��֤������Ч��
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
		   $.messager.alert("��ʾ","��עΪ��,����д��ע!");
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
	   $("body").remove("#"+id); //�Ƴ����ڵ�Dialog
	   $("#"+id).dialog('destroy');
   }
   function CheckIsCheckOrd(){
	   var SelOrdRowArr=InPatOrdDataGrid.datagrid('getChecked'); //ҽ�������Թ�ѡΪ׼,δ��ѡ��������
	   if (SelOrdRowArr.length==0){
		   $.messager.alert("��ʾ","û�й�ѡҽ��!")
		   return false;
	   }
	   var Length=0
	   $.each(SelOrdRowArr,function(Index,RowData){
			if (RowData.OrderId!=""){
				++Length;
			}
	   });
	   if (Length==0){
		   $.messager.alert("��ʾ","û�й�ѡҽ��!")
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
	   var h=myDate.getHours();       //��ȡ��ǰСʱ��(0-23)
	   var m=myDate.getMinutes();     //��ȡ��ǰ������(0-59)
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
			       		html +="	 "+$g("�Ƿ�Ԥͣ")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input class='hisui-checkbox' type='checkbox' id='isExpStopOrderCB'/>"
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("ֹͣ����")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='winStopOrderDate' disabled='false' class='hisui-datebox textbox' required='required'></input>"
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("ֹͣʱ��")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='winStopOrderTime' class='hisui-timespinner textbox' data-options='showSeconds:true'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("ִ�д���")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='winStopOrderTimes'  editable='false' class='textbox'></input>" //disabled='false'
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("����")
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
				       		html +="	 "+$g("����/����ԭ��")
				       	html +="	 </td>"
				       	html +="	 <td>"
				       		html +="	 <input id='OECStatusChReason' class='textbox'></input>"
				       	html +="	 </td>"
			        html +="	 </tr>"
			       
			   		html +="	 <tr>"
			       		html +="	 <td class='r-label'>"
			       			html +="	 "+$g("����")
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
			       		html +="	 "+$g("����/����ԭ��")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='OECStatusChReason' class='textbox'></input>"
			       	html +="	 </td>"
			       html +="	 </tr>"
			   html +="	</table>"
		   html += "</div>"
	   }else if((type=="NurR")||(type=="AddExec")){
		   var label1=$g("ִ������:"),label2=$g("ִ��ʱ��")
		   if (type=="AddExec") {
			   label1=$g("Ҫ��")+label1;
			   label2=$g("Ҫ��")+label2;
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
			       		html +="	 "+$g("����ʱ��")
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
			       		html +="	 "+$g("����")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdType' class='textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("����")
			       	html +="	 </td>"
			       	html +="	 <td class='r-label' class='r-label'>"
			       		html +="	 <input id='SeeOrdDate' class='hisui-datebox textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("ʱ��")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdTime' class='hisui-timespinner textbox' data-options='showSeconds:true'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("��ע")
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
			       		html +="	 "+$g("����")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdDate' class='hisui-datebox textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("ʱ��")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='SeeOrdTime' class='textbox'/> "
			       	html +="	 </td>"
			       html +="	 </tr>"
			       
			       html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("��ע")
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
			       			html +="	 "+$g("����")
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
	 * ����һ��ģ̬ Dialog
	 * @param id divId
	 * @param _url Div����
	 * @param _title ����
	 * @param _width ���
	 * @param _height �߶�
	 * @param _icon ICONͼ��
	 * @param _btntext ȷ����ťtext
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
	   //���ȥ���رհ�ť�����û�����������Ͻ�X�ر�ʱ�������޷��ص����������¼�����Ҫ����ƽ̨Э������
	   buttons.push({
		   text:$g('�ر�'),
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
			title=$g("��ѡ��һ��ҽ��!");
		}else if (record.TItemStatCode=="D"){
			title=$g("ҽ����ֹͣ,����ֹͣ!");
		}else if (record.TItemStatCode=="E"){
			title=$g("ҽ����ִ�й�,����ֹͣ!");
		}else if (record.StopPermission=="0"){
			title=$g("û��Ȩ��ֹͣ!");
		}*/
		return title;
	}
	function cancelOrderShowHandler(rowIndex,record){
		var index=$.hisui.indexOfArray(OrdRightTitleJson,"type","C")
		var title=OrdRightTitleJson[index].title;
		if (title!="") title=$g(title);
		/*var title="";
		if (record.OrderId==""){
			title=$g("��ѡ��һ��ҽ��!");
		}else if (record.TItemStatCode=="D"){
			title=$g("ҽ����ֹͣ,���ܳ���!");
		}else if (record.TItemStatCode=="E"){
			title=$g("ҽ����ִ�й�,���ܳ���!");
		}else if (record.TItemStatCode=="C"){
			title=$g("ҽ���ѳ���,���ܳ���!");
		}else if (record.TItemStatCode=="U"){
			title=$g("ҽ��������,���ܳ���!");
		}else if(record.CancelPermission == "0"){
			title = $g("Ȩ�޲��� �� ҽ���ѱ�ִ��!");
		}else if ((record.TPriorityCode=="S")||(record.TPriorityCode=="OMST")||(record.TPriorityCode=="OMCQZT")){
			title = $g("����ҽ����������!");
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
			title=$g("��ѡ��һ��ҽ��!");
		}else if (record.TItemStatCode=="D"){
			title=$g("ҽ����ֹͣ,��������!");
		}else if (record.TItemStatCode=="E"){
			title=$g("ҽ����ִ�й�,��������!");
		}else if (record.TItemStatCode=="U"){
			title=$g("ҽ��������,����������!");
		}else if(record.UnusePermission == "0"){
			title = $g("Ȩ�޲��� �� ҽ���ѱ�ִ��!");
		}*/
		return title;
	}
	function addOrderNotesHandler(){
	    destroyDialog("OrdDiag");
	    var Content=initDiagDivHtml("A");
	    var iconCls="icon-w-add";
	    createModalDialog("OrdDiag","���ӱ�ע", 380, 240,iconCls,"���ӱ�ע",Content,"MulOrdDealWithCom('A')");
	    //��ȡҽ�����б�ע
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
			title="��ѡ��һ��ҽ��!";
		}else if (record.AddNotePermission=="-1"){
			title="ҽ���Ѵ�ӡҽ����!";
		}else if (record.AddNotePermission=="-2"){
			title="ҽ����ʿ�����!";
		}else if (record.AddNotePermission=="-3"){
			title="�����ѽ����������!";
		}else if (record.AddNotePermission!="1"){
			title="��������ӱ�ע";
		}*/
		if (record.OrderId==""){
			title=$g("��ѡ��һ��ҽ��!");
		}else if (AddNotePermission=="-1"){
			title=$g("ҽ���Ѵ�ӡҽ����!");
		}else if (AddNotePermission=="-2"){
			title=$g("ҽ����ʿ�����!");
		}else if (AddNotePermission=="-3"){
			title=$g("�����ѽ����������!");
		}else if (AddNotePermission!="1"){
			title=$g("��������ӱ�ע");
		}
		return title;
	}
	function consultationHandler(){// dhcconsultpat.csp
		//window.showModalDialog("dhcem.consultmain.csp?PatientID="+ServerObj.PatientID+"&EpisodeID="+ServerObj.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:900px;resizable:yes");	
		websys_showModal({
			url:"dhcem.consultmain.csp?PatientID="+ServerObj.PatientID+"&EpisodeID="+ServerObj.EpisodeID,
			title:'��������',
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
			title=$g("������")+patDataObj.flagDesc+"!";
		}
		return title;
	}
	function surgeryApplyHandler(){ //dhcclinic.anop.app.csp
		//window.showModalDialog("dhcanoperapplication.csp?opaId=&appType=ward&EpisodeID="+ServerObj.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:1250px;resizable:yes");	
		websys_showModal({
			url:"dhcanoperapplication.csp?opaId=&appType=ward&EpisodeID="+ServerObj.EpisodeID,
			title:'��������',
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
			title=$g("������")+patDataObj.flagDesc+"!";
		}
		return title;
	}
	//��Ѫ���� ԭ�汾û�д���,�˰汾�ݲ�������
	function bloodApplyHandler(){}
	function bloodApplyShowHandler(){return "";}
	//�������ҽ�� ԭ�汾û�д���,�˰汾�ݲ�������
	function addBillOrderHandler(){}
	//��� ԭ�汾û�д���,�˰汾�ݲ�������
	function freeExecOrderHandler(){} 
	function freeExecOrderShowHandler(){return "";}
	//ȡ����� ԭ�汾û�д���,�˰汾�ݲ�������
	function cancelFreeExecOrderHandler(){}
	function cancelFreeExecOrderShowHandler(){return "";}
	//���ӷ��� ԭ�汾û�д���,�˰汾�ݲ�������
	function addFeeExecOrderHandler(){}
	function addFeeExecOrderShowHandler(){return "";}
	
	function OrderZSQShowHandler(rowIndex,record){
		var title="";
		if (record.ZSQUrl==""){
			title=$g("û����Ч��֪ʶ����Ϣ");
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
			title:'˵����',
			width:screen.availWidth-200,height:screen.availHeight-200
		});
	}
	function ChangeOrderDoseQtyShowHandler(rowIndex,record){
		var title=""
		if (record.OrderId==""){
			title=$g("��ѡ��һ��ҽ��!");
		}else if (record.TItemStatCode=="D"){
			title=$g("ҽ����ֹͣ,�����޸�!");
		}else if (record.TItemStatCode=="E"){
			title=$g("ҽ����ִ�й�,�����޸�!");
		}else if (record.StopPermission=="0"){
			title=$g("û��Ȩ���޸�!");
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
            $.messager.popover({msg: '��ѡ����Ҫ�޸ĵ�ҽ��',type:'alert'});
            return;
        }
        if(SelOrdRowStr.split("^").length>1){
            $.messager.popover({msg: 'ֻ��ѡ��һ��ҽ������',type:'alert'});
            return;
        }
        var OEORIRowid=SelOrdRowStr.split(String.fromCharCode(1))[0];
        var ret=tkMakeServerCall('web.DHCOEOrdItemDoseQty','HasDoseQtyRecord',OEORIRowid);
        if(ret==''){
	        $.messager.popover({msg: '�ǳ�����ҩҽ��,�����޸ĵ��μ���',type:'alert'});
            //return;
	    }
        var src = "ipdoc.order.doseqtystr.edit.hui.csp?OEORIRowid="+OEORIRowid;
	    //ShowHISUIWindow("�޸�ҽ�����μ���",src,"icon-edit",900,500);
		websys_showModal({
			url:src,
			title:'�޸Ĳ�����ҽ�����μ���',
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
	    createModalDialog("OrdDiag","���ӱ�ע", 380, 240,iconCls,"���ӱ�ע",Content,"MulOrdDealWithCom('A')");
	    //��ȡҽ�����б�ע
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
	
	
	//prn����ִ��ҽ��
	function addExecOrderHandler(){
		destroyDialog("OrdDiag");
	    var Content=initDiagDivHtml("AddExec");
	    var iconCls="icon-ok";
	    createModalDialog("OrdDiag","����ִ��ҽ��", 380, 260,iconCls,"ȷ��",Content,"MulOrdDealWithCom('Addexec')");
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
			title = $g("ҽ����ֹͣ,��������!");
			return title;
		}else if(PHFreqCode.toLocaleUpperCase() != "PRN"){
			title = $g("prnҽ����������!");
			return title ;
		}else if(PHFreqCode.toLocaleUpperCase() == "PRN" && oeoriOeoriDr!=""){
			title = $g("������ҽ��������ִ�м�¼!");			
			return title ;				
		}
		return title;
	}
	/*ִ�м�¼ִ����ط���*/
	function runExecOrderHandler(){
		if (!CheckIsCheckOrdExec()) return false;
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurR");
	    var iconCls="icon-exe-order";
	    createModalDialog("NurOrdDiag","ִ��", 380, 260,iconCls,"ȷ��",Content,"MulOrdDealWithCom('NurR')");
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
			title=$g("������")+patData.flagDesc+"!";
		}
		var execStatus = record.TExecStateCode;
		var orderStatCode = record.TItemStatCode;
		var IsCanExecOrdArrear = record.IsCanExecOrdArrear;
		if(execStatus != "C" && execStatus != $g("δִ��")) {
			title = $g("ֻ��δִ���볷��ִ�е�ִ�м�¼����ִ��!");
		}else if(orderStatCode == "U"){
			title = $g("ҽ��������!");
			return title;
		}else if(orderStatCode == "P"){
			title = $g("ҽ��Pre-Order!");
			return title;
		}else if(orderStatCode == "I"){
			title = $g("ҽ��δ��ʵ!");
			return title;
		}else if(IsCanExecOrdArrear=="FeeNotEnough"){
			title = $g("���ò���,����ִ��!");
			return title;
		}else if("SkinAbnorm"==IsCanExecOrdArrear){
			title = $g("Ƥ��ҽ�����Ϊ����,����ִ��!");
			return title;
		}else if("DrugSubOrder"==IsCanExecOrdArrear){
			title = $g("ҩƷ��ҽ��������ִ��!");
			return title;
		}else if("NotSeeOrd"==IsCanExecOrdArrear){
			title = $g("ҽ��δ����,����ִ��! ");
			return title;		
		}else if("NotIPMonitorRtn"==IsCanExecOrdArrear){
			title = $g("ҩƷ��˲�ͨ��,����ִ��! ");
			return title;		
		}			
		return title;  
	}
	function stopExecOrderHandler(){
		if (!CheckIsCheckOrdExec()) return false;
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurS");
	    var iconCls="icon-stop-order";
	    createModalDialog("NurOrdDiag","ִֹͣ��", 380, 260,iconCls,"ִֹͣ��",Content,"MulOrdDealWithCom('NurS')");
	    //��ʼ��ԭ��
	    InitOECStatusChReason();
	    $('#OECStatusChReason').next('span').find('input').focus();
	}
	function stopExecPrnOrderShowHandler(rowIndex,record){
		var title="";
		if (["3","4","5"].indexOf(ServerObj.patData.patFlag)>-1){
			title=$g("������")+patData.flagDesc+"!";
		}
		var execStatus = record.TExecStateCode;
		var orderStatCode = record.TItemStatCode;
		if(execStatus != "C" && execStatus != "δִ��") {
			title =$g( "ֻ��δִ���볷��ִ�е�ִ�м�¼����ֹͣ!");
			return title ;
		}else if(orderStatCode == "U"){
			title = $g("ҽ��������!");
			return title ;
		}else if(orderStatCode == "P"){
			title = $g("ҽ��Pre-Order!");
			return title ;
		}else if(orderStatCode == "I"){
			title = $g("ҽ��δ��ʵ!");
			return title ;
		}			
		return title;
	}
	function cancelExecOrderHandler(){
		if (!CheckIsCheckOrdExec()) return false;
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurC");
	    var iconCls="icon-cancel-order";
	    createModalDialog("NurOrdDiag","����ִ��", 380, 260,iconCls,"����ִ��",Content,"MulOrdDealWithCom('NurC')");
	    //��ʼ��ԭ��
	    InitOECStatusChReason();
	    $('#OECStatusChReason').next('span').find('input').focus();
	}
	function cancelExecOrderShowHandler(rowIndex,record){
		var title="";
		if (["3","4","5"].indexOf(ServerObj.patData.patFlag)>-1){
			this.qtitle = $g("˵��");
			title = $g("������")+patData.flagDesc+"!";
			return false;
		}
		var execStatus = record.TExecStateCode;
		var orderStatCode = record.TItemStatCode;
		/*ԭ�Ȱ汾 
		  IsMustApplyCancelOrdexec = tkMakeServerCall("web.DHCApplication","IsMustApplyCancel",oeori);
		  û�������,������
		*/
		/*var orgText=$('#Ordlayout_main').layout('panel', 'east').panel('setTitle',OrdInfo);
		if(orgText.indexOf("����")!=-1){
			orgText = orgText.slice(2);
		}
		if(IsMustApplyCancelOrdexec==1){
			IsMustApplyCancelText = "����"+orgText;
		}else{
			IsMustApplyCancelText = orgText;
		}		
		this.setText(IsMustApplyCancelText);*/
		if(execStatus != "F") {
			title = $g("��ִ�еĲ��ܳ���!");
			return title ;
		}
		if(orderStatCode=="E"){
			title = $g("ҽ��״̬Ϊִ�в��ܳ���ִ�У�!");
			return title ;
		}
		var applyCancelStatusCode = record.TApplyCancelStatusCode;
		if (applyCancelStatusCode=="A"){
			title = $g("�����볷��,��ȴ����!");
			return title;
		}
		if(record.IsCancelArrivedOrd==0){
			title = $g("���Ƽ�¼�Ѿ�����,���ܳ���ִ��!");
			return title;
		}
		return title;
	}
	function UpdateHourOrderEndTimeHandler(){
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurUpdateEndTime");
	    var iconCls="icon-ok";
	    createModalDialog("NurOrdDiag","�޸�Сʱҽ������ʱ��", 380, 260,iconCls,"ȷ��",Content,"MulOrdDealWithCom('NurUpdateEndTime')");
	    //��ʼ��ԭ��
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
		//���ú�̨�޸�Сʱҽ������ʱ��
		var time=$('#winHourEndTime').combobox('getText');
	   if (time==""){
		   $.messager.alert("��ʾ","����ʱ�䲻��Ϊ��!","info",function(){
			   $('#winHourEndTime').next('span').find('input').focus();
		   });
		   return false;
	   }
	   if (!IsValidTime(time)){
		   $.messager.alert("��ʾ","����ʱ���ʽ����ȷ! ʱ:��:��,��11:05:01","info",function(){
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
				$.messager.alert("��ʾ",val);
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
			title = $g("������")+patData.flagDesc+"!";
			return title;
		}
		var IsHourOrder = record.TBillUom=="HOUR" ? true : false;
		if(!IsHourOrder){
			title = "����Сʱҽ��!";
			return title ;
		}
		var execStatus = record.TExecStateCode;
		if(execStatus != "D") {
			title = "ִ�м�¼ֹͣ������޸�ʱ��!";
			return title ;
		}
		return title;
	}
	function NuraddOrderNotesHandler(){
		destroyDialog("NurOrdDiag");
	    var Content=initDiagDivHtml("NurA");
	    var iconCls="icon-add-note";
	    createModalDialog("NurOrdDiag","���ӱ�ע", 380, 260,iconCls,"���ӱ�ע",Content,"MulOrdDealWithCom('NurA')");
	    //��ȡִ�м�¼���б�ע
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
	//��ʿ����ִ�м�¼��ע
	function NurAddOrderNotes(){
	   var OrderExecNotes=$("#OrderExecNotes").val();
	   if (OrderExecNotes==""){
		   $.messager.alert("��ʾ","��עΪ��,����д��ע!");
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
	   var SelOrdExecRowArr=InPatOrdExecDataGrid.datagrid('getChecked'); //ҽ�������Թ�ѡΪ׼,δ��ѡ��������
	   if (SelOrdExecRowArr.length==0){
		   $.messager.alert("��ʾ","û�й�ѡִ�м�¼!")
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
    //ִ�м�¼����������,��type���ֲ�ͬ����
    function MulOrdExecDealWithCom(type){
	   var date="",time="",ReasonId="",Reasoncomment="";
	   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
	   if ((type=="C")||(type=="D")){ //����ִ�� ִֹͣ��
		   ReasonId=$("#OECStatusChReason").combobox("getValue");
		   Reasoncomment=$("#OECStatusChReason").combobox("getText");
		   if (ReasonId==Reasoncomment) ReasonId="";
		   else if (ReasonId!="") Reasoncomment="";
		   if ((ReasonId=="")&&(Reasoncomment=="")){
			   $.messager.alert("��ʾ","��ѡ�������дԭ��!");
			   $('#OECStatusChReason').next('span').find('input').focus();
			   return false;
		   }
		   ExpStr=ExpStr+"^"+Reasoncomment;
	   }else if (type=="R"){
		   var date = $('#winRunOrderDate').datebox('getValue');
		   if (date==""){
			   $.messager.alert("��ʾ","ִ�����ڲ���Ϊ��!");
			   $('#winRunOrderDate').next('span').find('input').focus();
			   return false;
		   }
		   if(!DATE_FORMAT.test(date)){
			   $.messager.alert("��ʾ","ִ�����ڸ�ʽ����ȷ!");
			   return false;
		   }
		   var time=$('#winRunOrderTime').combobox('getText');
		   if (time==""){
			   $.messager.alert("��ʾ","ִ��ʱ�䲻��Ϊ��!");
			   $('#winRunOrderTime').next('span').find('input').focus();
			   return false;
		   }
		   if (!IsValidTime(time)){
			   $.messager.alert("��ʾ","ִ��ʱ���ʽ����ȷ! ʱ:��:��,��11:05:01");
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
				$.messager.alert("��ʾ",val);
				LoadInPatOrdExecDataGrid();
				return false;
			}
		});
    }
    //������ϸ
    function execFeeDataShow(execRowId){
	   destroyDialog("execFeeDiag");
	   var Content="<table id='tabExecFee' cellpadding='5' style='margin:5px;border:none;'></table>";
	   var iconCls="";
	   createModalDialog("execFeeDiag",$g("������ϸ"), 550, 350,iconCls,"",Content,"");
	    
	   var ExecFeeColumns=[[ 
		 			{field:'FeeId',hidden:true,title:''},
		 			{field:'TCancelStatu',hidden:true,title:''},
		 			{field:'TTarDesc',title:'�շ�������'},
		 			{field:'TTarCode',title:'����'},
		 			{field:'TQty',title:'����'},
		 			{field:'TPrice',title:'����'},
		 			{field:'TAmount',title:'���'},
		 			{field:'TDate',title:'����ʱ��'},
		 			{field:'TExtralComment',title:'ԭ��'}
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
			title:'ҽ����ϸ',
			width:400,height:screen.availHeight-200
		});
	}
	function OpenOrderView(OEItemID){
		//$.orderview.show(OEItemID);
		websys_showModal({
			url:"dhc.orderview.csp?ord=" + OEItemID,
			title:'ҽ���鿴',
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
		//���ÿ�ѡ���¼�����ֹ��ֵʱ����LoadPatOrdDataGrid��
		//1��Ч�����⣬2���ظ�����LoadPatOrdDataGrid����scrollview��ͻ������onLoadSuccessʧЧ
		o.jdata.options.stateonChecked = o.jdata.options.onChecked;
		o.jdata.options.onChecked = function(){};
		///����������S��Ȼ���ٸ�S��checked,�����ᴥ��oncheck�¼�;
		//�����ǰѡ�����Ҫ��ѯ������һ��,����ע������,�ƹ�����ж�,ǿ�Ʋ�ˢ��
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
		GridParams.Arg11=""; //����ֻ��ҽ��¼�����������Ժ��ҩ��ʱ����ʱҽ����ֻ��ʾ����Ժ��ҩ����������ʾ��ʱҽ��+��Ժ��ҩ
	}
	function SelNextDocOrdBak(){
		//�Զ�ѡ����һ��ҽ��
		var par_win=GetOrdPatWin();
		if (!par_win){return false;}
		if (typeof par_win.SetVerifiedOrder != "function"){return false;}
		var SelRowListRowData=InPatOrdDataGrid.datagrid('getSelections');
		
		var SelRowList=[];
		///ɾ���Ǳ�ҳ������
		var SelRowIndex="";
		$.each(SelRowListRowData,function(Index,RowData){
			var RowIndex=InPatOrdDataGrid.datagrid('getRowIndex',RowData.OrderId);
			if ((RowIndex>=0)){
				SelRowList.push(RowData);
				SelRowIndex=RowIndex;
			}
		});
		///��ҳѡ�е�����
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
		/*������һ��*/
		var NextRowIndex="";
		var FindCurrSel=0;
		/*��Ҫ��ҳ��ҳ��*/
		var ScorllPageNum=0;
		for (i=start;i<ListData.originalRows.length;i++){
			//�ӱ���ҽ��������
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
			/*û�ҵ��������,���ѡ�� par_win.SetVerifiedOrder("");*/
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
			$("#changeBigBtn")[0].innerText=$g("��С");
		}else{
			flagbig=1
			$(ele).removeClass('expanded');
			$("#changeBigBtn")[0].innerText=$g("�Ŵ�");
		}
		/*var p = $("#OrdSearch-div > .layout-panel-center:first");
		var Height = $(window).height()-$("#OrdSearch-div").outerHeight()+p.outerHeight()-2;
		p.css({height:Height});
		window.setTimeout(function() {
			InPatOrdDataGrid.datagrid("resize");
		},300);*/
	}
	function toggleExecInfo(ele){
		if ($(ele).hasClass('expanded')){  //�Ѿ�չ�� ����
			$(ele).removeClass('expanded');
			$("#moreBtn")[0].innerText=$g("����");
	    	$("#more").hide(); //#dashline
	    	setHeight("-39");
		}else{
			$(ele).addClass('expanded');
			$("#moreBtn")[0].innerText=$g("����");
	    	$("#more").show(); //#dashline
	    	setHeight('39');
		}
		function setHeight(num){
			var p=$("#OrdSearch-div > .layout-panel-north:first");
			var Height=parseInt(p.outerHeight())+parseInt(num);
			p.css({height:Height});
			
			//��ô��Ч��ֹǿ��ͬ������
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
			alert($g("ǩ��ʧ��"));
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
			//1.������֤
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
					//$.messager.alert("����","OEORIItemXML:"+OEORIItemXML);
					var OEORIItemXMLHash=HashData(OEORIItemXML);
					//$.messager.alert("����","HashOEORIItemXML:"+OEORIItemXMLHash);
					if(SignOrdHashStr=="") SignOrdHashStr=OEORIItemXMLHash;
					else SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&"+OEORIItemXMLHash;
					//$.messager.alert("����",ContainerName);
					var SignedData=SignedOrdData(OEORIItemXMLHash,ContainerName);
					if(SignedOrdStr=="") SignedOrdStr=SignedData;
					else SignedOrdStr=SignedOrdStr+"&&&&&&&&&&"+SignedData;
					if(CASignOrdValStr=="") CASignOrdValStr=OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
					else CASignOrdValStr=CASignOrdValStr+"^"+OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
				}
			}
			if (SignOrdHashStr!="")SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&";
			if (SignedOrdStr!="")SignedOrdStr=SignedOrdStr+"&&&&&&&&&&";
			//��ȡ�ͻ���֤��
	    	var varCert = GetSignCert(ContainerName);
	    	var varCertCode=GetUniqueID(varCert);
			/*
			alert("CASignOrdStr:"+CASignOrdStr);
			alert("SignOrdHashStr:"+SignOrdHashStr);
			alert("varCert:"+varCert);
			alert("SignedData:"+SignedOrdStr);
			*/
	    	if ((CASignOrdValStr!="")&&(SignOrdHashStr!="")&&(varCert!="")&&(SignedOrdStr!="")){
				//3.����ǩ����Ϣ��¼																												CASignOrdValStr,session['LOGON.USERID'],"A",					SignOrdHashStr,varCertCode,SignedOrdStr,""
				var ret=cspRunServerMethod(ServerObj.InsertCASignInfoMethod,CASignOrdValStr,session['LOGON.USERID'],OperationType,SignOrdHashStr,varCertCode,SignedOrdStr,"");
				if (ret!="0") {
					alert($g("����ǩ��û�ɹ�"));
					return false;
				}else{
					alert("CA sucess")
				}
			}else{
		  		alert($g("����ǩ������"));
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
	    createModalDialog("OrdDiag","����Ԥͣ", 380, 260,iconCls,"����Ԥͣ",Content,"MulOrdDealWithCom('CancelPreStopOrd')");
	    $('#winPinNum').focus();
	}
	function cancelPreStopOrdShowHandle(rowIndex,record){
		var title=$g("��Ԥͣ״̬ҽ��!");
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
		// ����ʶswitchSysPatΪN,�õ���request�ڵĲ���,�Ҳ����л�����
		if ((parent.switchSysPat)&&(parent.switchSysPat=="N")) {
			FixedEpisodeID=EpisPatObj.EpisodeID;
		}
		//���Ҽ�ˢ��ʱ���ᶨλ�����ѡ��Ļ���
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
		//��ֹ����������ֲ�ˢ��ʱҳ����ʾ�հ�
		ForceRefreshLayout();
		//�ر����е�dialog,window,message
		$(".panel-body.window-body").each(function(index,element){
			$(element).window("destroy");
		});
		InPatOrdDataGridLoadSuccCallBack.add(CallBackFunc);
		/*
		///tanjishan 2019-07-08���Σ�������������ʱ���ڵ��ö��xrh������bug�������ٳ���onloadsuccess�����õ�����
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
		   $.extend(rtnObj, { msg: $g("δѡ����Ҫ������������!"),success:false});
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
		   $.extend(rtnObj, { msg: $g("δѡ����Ҫ������������!"),success:false});
		   return rtnObj;
	   }
	   if ((oeoris!="")&&(CMoeoris!="")) {
		   $.extend(rtnObj, { msg: $g("��ҩ�Ͳ�ҩ����ͬʱ����!"),success:false});
		   return rtnObj;
	   }
	   var toTitle=$g("ҽ��¼��");
	   if (oeoris=="") oeoris=CMoeoris,toTitle=$g("��ҩ¼��");
	   oeoris=oeoris.split("^").sort(function(num1,num2){
	       return parseFloat(num1.split("||")[1])-parseFloat(num2.split("||")[1]);
	   }).join("^");
	   $.extend(rtnObj, { data: oeoris,toTitle:toTitle});
	   return rtnObj;
   }
   ///��ȡ�Ҽ���ťȨ����ʾ��Ϣ
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
	   //����Ԥͣ
	   "cancelPreStopOrdHandle":cancelPreStopOrdHandle,
	   "cancelPreStopOrdShowHandle":cancelPreStopOrdShowHandle,
	   //���·���,ԭ�汾δ��ʵ��,�˰汾ֻ�����ӿ�
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
