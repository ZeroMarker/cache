// JavaScript Document

$(function(){
	//************************布局内容初始化--开始****************************//
	//var Order_DataGrid; //定义全局变量datagrid   
	//医嘱录入表格
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
			emptyrecords:'没有数据',
			viewrecords:true,
			loadtext:'数据加载中...',
			multiselect:true,//多选
			multiboxonly:true,
			rowNum:false,
			//rowList:[10,20,30],
			loadonce:false, //请求一次数据  本地分页
			//pager:'#Order_DataGrid_pagbar',
			//onPaging:uppage,		
			viewrecords: true,
			//sortorder: "desc",
			//caption:"医嘱录入",
			rownumbers:false,
			loadui:'enable',//disable禁用ajax执行提示；enable默认，当执行ajax请求时的提示； block启用Loading提示，但是阻止其他操作
			loadError:function(xhr,status,error){
				alert("oeorder.oplistcustom.show.js-err:"+status+","+error);
				//xhr：XMLHttpRequest 对象；status：错误类型，字符串类型；error：exception对象
			},
			//userDataOnFooter:true,
			//userdata: {totalinvoice:240.00, tax:40.00}, //返回的额外信息
			colNames:ListConfigObj.colNames,			
			colModel:ListConfigObj.colModel,			
			//footerrow: true,//分页上添加一行，用于显示统计信息					
			jsonReader: {
                    page: "page",
                    total: "total",
                    records: "records",
                    root: "data",
                    repeatitems: false,
                    id: "id"
            },
			prmNames:{
				page:"page",//表示请求页码的参数名称
				rows:"rows",//表示请求行数的参数名称
				sort:"sidx",//表示用于排序的列名的参数名称
				order:"sord",//表示采用的排序方式的参数名称
				search:"_search",//表示是否是搜索请求的参数名称
				nd:"nd",//表示已经发送请求的次数的参数名称
				id:"id",//表示当在编辑数据模块中发送数据时，使用的id的名称
				oper:"oper",//operation参数名称（我暂时还没用到）
				editoper:"edit",//当在edit模式中提交数据时，操作的名称request.getParameter("oper") 得到edit
				addoper:"add",//当在add模式中提交数据时，操作的名称request.getParameter("oper") 得到add
				deloper:"del",//当在delete模式中提交数据时，操作的名称request.getParameter("oper") 得到del
				subgridid:"id",//当点击以载入数据到子表时，传递的数据名称
				npage:null,
				totalrows:"totalrows" //表示需从Server得到总共多少行数据的参数名称，参见jqGrid选项中的rowTotal
			},
			
			ondblClickRow:function(rowid,iRow,iCol,e){
				//双击行时触发。rowid：当前行id；iRow：当前行索引位置；iCol：当前单元格位置索引；e:event对象
				//alert("rowid:"+rowid);
				//var itemid=GetCellData(rowid,"OrderItemRowid");
				
				//行号
				//var Ind=$('#Order_DataGrid').getInd(rowid);
				//检查关联 存在关联 关联行全部启动编辑
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
				//已经被beforeSelectRow禁止行选择操作
			},
			onSelectRow:function(rowid,status){	
				//获取列名
				/*
				var colModel=$("#Order_DataGrid").jqGrid('getGridParam','colModel');
				alert(colModel[1].name);
				*/
				//EditRow(rowid);
				//检查关联 选择主医嘱 子医嘱也选中
				//alert($("#jqg_Order_DataGrid_"+rowid).attr("checked"));
				
				SelectContrl(rowid);
				
			},
			beforeSelectRow:function(rowid, e){	
				if ($.isNumeric(rowid) == true) {
					PageLogicObj.FocusRowIndex=rowid;
				}else{
					PageLogicObj.FocusRowIndex=0;
				}
				return true;//false 禁止选择行操作
			},
			onRightClickRow:function(rowid,iRow,iCol,e){
				//在行上右击鼠标时触发此事件。rowid：当前行id；iRow：当前行位置索引；iCol：当前单元格位置索引；e：event对象
				
				//createRowContextMenu(rowid);
				if (typeof YLYYOnRightClick=="function"){
					YLYYOnRightClick(rowid);
				}
			},
			formatCell: function (rowid, cellname, value, iRow, iCol){
				
                //alert(iCol);              
			},
			gridComplete:function(){
				//加载完成后 增加 删除 都会调用
				$("#Order_DataGrid td").removeAttr("title");
			},
			loadComplete:function(){
				setTimeout(function (){
					//获取审核数据
					//alert("loadComplete");		
					//获取session数据
					GetSessionData(); 
					
					//加载完成后 增加 删除 都会调用			
					var records=$('#Order_DataGrid').getGridParam("records");
					//if(records==0){
						Add_Order_row();
					//}
					//从医嘱单界面复制医嘱,只提醒一次
					if(('undefined' !== typeof CopyOeoriDataArr)&&(CopyOeoriDataArr.length>0)){
						AddCopyItemToList(CopyOeoriDataArr);
						CopyOeoriDataArr=undefined;
					}
					//改变已经审核医嘱的颜色
					var rowids=$('#Order_DataGrid').getDataIDs();
					for(var i=0;i<rowids.length;i++){
						if(CheckIsItem(rowids[i])==true) {
							var OrderName=GetCellData(rowids[i],"OrderName");
							$('#Order_DataGrid').setCell(rowids[i],"OrderName",OrderName,"OrderSaved","");
						}else{
							//设定毒麻处方背景色
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
					//护士执行-绑费用
					SetOrdNurseBindOrd();
				},200);
				//调整表格的宽度和高度,如出现医嘱审核按钮区浮动到表格行上方的情况,可放开此句
				//setTimeout(function (){ResizeGridWidthHeiht("resize");},1000);
			}
							
	});
	//工具栏
	/*
	$("#Order_DataGrid").jqGrid('inlineNav',"#Order_DataGrid_pagbar");
	//elem, o, pEdit,pAdd,pDel,pSearch, pView
	$("#Order_DataGrid").jqGrid('navGrid',"#Order_DataGrid_pagbar",{
		edit:true,add:true,del:true
	}
	);
	*/
	//$("#Order_DataGrid").navButtonAdd("#Order_DataGrid_pagbar",{ caption:"NewButton", buttonicon:"ui-icon-newwin", onClickButton:null, position: "last", title:"", cursor: "pointer"});
	
	//固定列
	//$("#Order_DataGrid").jqGrid('setFrozenColumns');
	//加载模版 (默认加载个人 或者 科室)
	/*
	jQuery("#ButtonList").append(
		jQuery("<img>",{
			id:"UIConfigImg",
			src:"../images/DesinerImg/ctrlImg/example.gif",
			alt:"UI_Config",
			title:"用户UI设置",
			live:{
				click:function() {
					var UIConfigImgURL="oeorder.oplistcustom.config.csp"
					window.open(UIConfigImgURL,"","status=1,scrollbars=1,top=100,left=100,width=760,height=420")
				}
			}
		})
	);
	*/
	//************************布局内容初始化--结束******************************//
	
	
	
	
});