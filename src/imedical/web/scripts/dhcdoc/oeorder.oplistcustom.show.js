// JavaScript Document

$(function(){
	//************************�������ݳ�ʼ��--��ʼ****************************//
	//var Order_DataGrid; //����ȫ�ֱ���datagrid   
	//ҽ��¼����
	var mydata = [];		
	var lastSel;
	$("#Order_DataGrid").jqGrid({
			//data: mydata,
			//datatype: "local",
			url:'oeorder.oplistcustom.new.request.csp?action=GetOrderList',
			datatype: "json",
			postData:{USERID:session['LOGON.USERID'],ADMID:GlobalObj.EpisodeID,NotDisplayNoPayOrd:GlobalObj.NotDisplayNoPayOrd},
			editurl:'clientArray',
			//height:gridHeight,//GlobalObj.CFDafaultEntryHeight,
			//width:1132,
			//autowidth:true,
			//autoheight:true,
			shrinkToFit: false,
			mtype:'POST',
			emptyrecords:'û������',
			viewrecords:true,
			loadtext:'���ݼ�����...',
			multiselect:true,//��ѡ
			multiboxonly:true,
			rowNum:false,
			//rowList:[10,20,30],
			loadonce:false, //����һ������  ���ط�ҳ
			//pager:'#Order_DataGrid_pagbar',
			//onPaging:uppage,		
			viewrecords: true,
			//sortorder: "desc",
			//caption:"ҽ��¼��",
			rownumbers:false,
			loadui:'enable',//disable����ajaxִ����ʾ��enableĬ�ϣ���ִ��ajax����ʱ����ʾ�� block����Loading��ʾ��������ֹ��������
			loadError:function(xhr,status,error){
				alert("oeorder.oplistcustom.show.js-err:"+status+","+error);
				//xhr��XMLHttpRequest ����status���������ͣ��ַ������ͣ�error��exception����
			},
			//userDataOnFooter:true,
			//userdata: {totalinvoice:240.00, tax:40.00}, //���صĶ�����Ϣ
			colNames:ListConfigObj.colNames,			
			colModel:ListConfigObj.colModel,			
			//footerrow: true,//��ҳ�����һ�У�������ʾͳ����Ϣ					
			jsonReader: {
                    page: "page",
                    total: "total",
                    records: "records",
                    root: "data",
                    repeatitems: false,
                    id: "id"
            },
			prmNames:{
				page:"page",//��ʾ����ҳ��Ĳ�������
				rows:"rows",//��ʾ���������Ĳ�������
				sort:"sidx",//��ʾ��������������Ĳ�������
				order:"sord",//��ʾ���õ�����ʽ�Ĳ�������
				search:"_search",//��ʾ�Ƿ�����������Ĳ�������
				nd:"nd",//��ʾ�Ѿ���������Ĵ����Ĳ�������
				id:"id",//��ʾ���ڱ༭����ģ���з�������ʱ��ʹ�õ�id������
				oper:"oper",//operation�������ƣ�����ʱ��û�õ���
				editoper:"edit",//����editģʽ���ύ����ʱ������������request.getParameter("oper") �õ�edit
				addoper:"add",//����addģʽ���ύ����ʱ������������request.getParameter("oper") �õ�add
				deloper:"del",//����deleteģʽ���ύ����ʱ������������request.getParameter("oper") �õ�del
				subgridid:"id",//��������������ݵ��ӱ�ʱ�����ݵ���������
				npage:null,
				totalrows:"totalrows" //��ʾ���Server�õ��ܹ����������ݵĲ������ƣ��μ�jqGridѡ���е�rowTotal
			},
			
			ondblClickRow:function(rowid,iRow,iCol,e){
				//˫����ʱ������rowid����ǰ��id��iRow����ǰ������λ�ã�iCol����ǰ��Ԫ��λ��������e:event����
				//alert("rowid:"+rowid);
				//var itemid=GetCellData(rowid,"OrderItemRowid");
				
				//�к�
				//var Ind=$('#Order_DataGrid').getInd(rowid);
				//������ ���ڹ��� ������ȫ�������༭
				var AllRowids = GetAllRowId();
				var rowidArr=GetOrderSeqArr(rowid);
				//alert(rowidArr);
				var NeedOpenChangeOrder=false;
				for(var key in rowidArr){
					var OrderType=GetCellData(rowidArr[key],"OrderType");
					var OrderItemRowid=GetCellData(rowidArr[key],"OrderItemRowid");
					//s TmInfo=##class(DHCDoc.Interface.Inside.Invoke).GetTmInfoByOrderRowId(OrItemID)
					if( OrderItemRowid != "" && OrderItemRowid != null && OrderItemRowid != undefined){
						if (OrderType == "R"){
							var isAnt = tkMakeServerCall("DHCAnt.Serve.ComOut", "IsAntiDrug", OrderItemRowid)
							if (isAnt==1) {
								return;
							}else{
								NeedOpenChangeOrder=true;
							}
						}else if(OrderType == "L"){
							var TmInfo=tkMakeServerCall("web.UDHCStopOrderLook","GetLabAppenOrdInfo",OrderItemRowid)
							if (TmInfo!=""){
								for (var j=0;j<TmInfo.split("^").length;j++){
									var TmOrdItemRowid=TmInfo.split("^")[j].split("&")[0];
									for (var k=key;k<AllRowids.length;k++){
										var tmpOrdrItemRowid=GetCellData(AllRowids[k],"OrderItemRowid");
										if (tmpOrdrItemRowid==TmOrdItemRowid){
											if ($("#jqg_Order_DataGrid_" + AllRowids[k]).prop("checked") != true) {
								                $("#Order_DataGrid").setSelection(AllRowids[k], true);
								            }
								            break;
										}
									}
								}
							}
							NeedOpenChangeOrder=true;
						}else{
							NeedOpenChangeOrder=true;
						}
					}
				}
				if (NeedOpenChangeOrder){
					OpenChangeOrderClick()
					return
				}
				for(var key in rowidArr){
					//alert(rowidArr[key])
					EditRow(rowidArr[key]);	
				}						
			},
			
			onCellSelect:function(rowid,iCol,cellcontent,e){
				//alert("cellcontent="+cellcontent);
			},
			onClickRow:function(rowIndex, rowData){
				//�Ѿ���beforeSelectRow��ֹ��ѡ�����
			},
			onSelectRow:function(rowid,status){	
				//��ȡ����
				/*
				var colModel=$("#Order_DataGrid").jqGrid('getGridParam','colModel');
				alert(colModel[1].name);
				*/
				//EditRow(rowid);
				//������ ѡ����ҽ�� ��ҽ��Ҳѡ��
				//alert($("#jqg_Order_DataGrid_"+rowid).attr("checked"));
				
				SelectContrl(rowid);
				
			},
			beforeSelectRow:function(rowid, e){	
				if ($.isNumeric(rowid) == true) {
					PageLogicObj.FocusRowIndex=rowid;
				}else{
					PageLogicObj.FocusRowIndex=0;
				}
				return true;//false ��ֹѡ���в���
			},
			onRightClickRow:function(rowid,iRow,iCol,e){
				//�������һ����ʱ�������¼���rowid����ǰ��id��iRow����ǰ��λ��������iCol����ǰ��Ԫ��λ��������e��event����
				
				//createRowContextMenu(rowid);
				if (typeof YLYYOnRightClick=="function"){
					YLYYOnRightClick(rowid);
				}
			},
			formatCell: function (rowid, cellname, value, iRow, iCol){
				
                //alert(iCol);              
			},
			gridComplete:function(){
				//������ɺ� ���� ɾ�� �������
				$("#Order_DataGrid td").removeAttr("title");
			},
			loadComplete:function(){
				setTimeout(function (){
					//��ȡ�������
					//alert("loadComplete");		
					//��ȡsession����
					GetSessionData(); 
					
					//������ɺ� ���� ɾ�� �������			
					var records=$('#Order_DataGrid').getGridParam("records");
					//if(records==0){
						Add_Order_row();
					//}
					//��ҽ�������渴��ҽ��,ֻ����һ��
					if(('undefined' !== typeof CopyOeoriDataArr)&&(CopyOeoriDataArr.length>0)){
						AddCopyItemToList(CopyOeoriDataArr);
						CopyOeoriDataArr=undefined;
					}
					//�ı��Ѿ����ҽ������ɫ
					var rowids=$('#Order_DataGrid').getDataIDs();
					for(var i=0;i<rowids.length;i++){
						if(CheckIsItem(rowids[i])==true) {
							var OrderName=GetCellData(rowids[i],"OrderName");
							$('#Order_DataGrid').setCell(rowids[i],"OrderName",OrderName,"OrderSaved","");
						}else{
							//�趨���鴦������ɫ
					        var OrderPoisonCode=GetCellData(rowids[i], "OrderPoisonCode");
					        var OrderPoisonRowid=GetCellData(rowids[i], "OrderPoisonRowid");
							SetPoisonOrderStyle(OrderPoisonCode, OrderPoisonRowid, rowids[i])
							//if (GlobalObj.OEORIRealTimeQuery==1) SetOrdNameList(rowids[i])
						}
						var OrderMasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
					    if (OrderMasterSeqNo != "") {
					        $("#" + OrderMasterSeqNo).find("td").addClass("OrderMasterM");
					        $("#" + rowids[i]).find("td").addClass("OrderMasterS");
					    }
					}
					if (GlobalObj.HLYYInterface==1){
						if (GlobalObj.CurrCompanyCode=="MK"){
							//MKXHZYNoView()
						}else if (GlobalObj.CurrCompanyCode=="DT"){
							//DaTongXHZYHander();
							XHZYClickHandler_HLYY();
						}
		            }
					SetScreenSum();
					//��ʿִ��-�����
					SetOrdNurseBindOrd();
				},200);
				//�������Ŀ�Ⱥ͸߶�,�����ҽ����˰�ť��������������Ϸ������,�ɷſ��˾�
				//setTimeout(function (){ResizeGridWidthHeiht("resize");},1000);
			}
							
	});
	//������
	/*
	$("#Order_DataGrid").jqGrid('inlineNav',"#Order_DataGrid_pagbar");
	//elem, o, pEdit,pAdd,pDel,pSearch, pView
	$("#Order_DataGrid").jqGrid('navGrid',"#Order_DataGrid_pagbar",{
		edit:true,add:true,del:true
	}
	);
	*/
	//$("#Order_DataGrid").navButtonAdd("#Order_DataGrid_pagbar",{ caption:"NewButton", buttonicon:"ui-icon-newwin", onClickButton:null, position: "last", title:"", cursor: "pointer"});
	
	//�̶���
	//$("#Order_DataGrid").jqGrid('setFrozenColumns');
	//����ģ�� (Ĭ�ϼ��ظ��� ���� ����)
	/*
	jQuery("#ButtonList").append(
		jQuery("<img>",{
			id:"UIConfigImg",
			src:"../images/DesinerImg/ctrlImg/example.gif",
			alt:"UI_Config",
			title:"�û�UI����",
			live:{
				click:function() {
					var UIConfigImgURL="oeorder.oplistcustom.config.csp"
					window.open(UIConfigImgURL,"","status=1,scrollbars=1,top=100,left=100,width=760,height=420")
				}
			}
		})
	);
	*/
	//************************�������ݳ�ʼ��--����******************************//
	
	
	
	
});