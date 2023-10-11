var paramObj={};
var urlCfgObj={};
$(function(){
	Init();
	InitEvent();
});
function InitEvent()
{
	document.onkeydown = Doc_OnKeyDown;
	$('#NurseOrd').checkbox({
	    onCheckChange:function(e,value){
		    NurseOrdClickHandler(value);
		}
	});
}
function Init()
{
	InitPatOrderViewGlobal(GlobalObj.EpisPatInfo);
	urlCfgObj={
	    'templateFrame':'oeorder.entry.template.csp?TemplateRegion='+ServerObj.TemplateRegion,
	    'ordListFrame':(ServerObj.isNurseLogin?'ipdoc.patorderviewnurse.csp':'ipdoc.patorderview.csp')+'?PageShowFromWay=ShowFromOrdEntry'
	};
	if(typeof websys_writeMWToken=='function'){
		$.each(urlCfgObj,function(key,value){
			urlCfgObj[key]=websys_writeMWToken(value);
		});
	}
	PageLogicObj.TempHeight=ServerObj.TempHeightScale?($('#layoutMain').height()*ServerObj.TempHeightScale/100):400;
	PageLogicObj.TempWidth=ServerObj.TempWidthScale?($('#layoutMain').width()*ServerObj.TempWidthScale/100):300;
	InitOrdListFrame();
    InitTempFrame();
    InitOrdListLayout();
	xhrRefreshFrame(urlToObj(window.location.href));
    InitOrderEntryGrid();
	setTimeout(function(){AntLoad();});
	InitPrompt();
	initDivHtml();
	//初始化慢病病种LookUp
    InitChronicDiagLookUp();
    //初始化医生
    InitLogonDocStr();
    //对外接口初始化
	Common_ControlObj.Init();
}
function InitOrdListFrame()
{
    if(ServerObj.OrdListRegion=='') return;
    var resizeTimer=null;
    $('#pCenter').layout('add',{
        region:ServerObj.OrdListRegion,
        border:false,
        collapsible:false,
        split:true,
        height:PageLogicObj.TempHeight,
        content:'<div id="tabOrdList"></div>',
        onResize:function(){
	    	clearTimeout(resizeTimer);
	    	resizeTimer=setTimeout(function(){
		    	var tab=$('#tabOrdList').tabs('getSelected')
		    	$('#tabOrdList').tabs('options').onSelect.call($('#tabOrdList')[0],tab.panel('options').title);
		    },500);
		    ResetOrdListScale($(this).outerHeight(),0,ServerObj.OrdListRegion);
	    }
    });
    $('#tabOrdList').tabs({   
        fit:true, 
        border:false,
        tabHeight:30,
        showHeader:false,
        onSelect:function(title){
            var tab=$(this).tabs('getTab',title);
            var onSelect=tab.panel('options').onSelect;
            if(onSelect){
	            //如果没选择该页签,医为浏览器加载数据后会出现显示问题,需要resize一下
	            var $body=tab.panel('body');
	            if($body.children('iframe').attr('src')&&$body.children('iframe')[0].contentWindow.$){
	            	onSelect.call(tab[0],$body.children('iframe')[0].contentWindow);
		        }
            }
        }
    }).tabs('add',{
        title:'医嘱列表',
        selected:true,
        content:"<iframe id='ordListFrame' name='ordListFrame' width='100%' height='100%' frameborder='0'></iframe>",
        onSelect:function(children){
	        setTimeout(function(){	
	        	//医嘱列表界面布局后续需要优化
				if(children.$('#Ordlayout_main').hasClass('hisui-layout')){
					children.$('#Ordlayout_main').layout('resize');
				}
				if(children.$('#OrdSearch-div').hasClass('hisui-layout')){
					children.$('#OrdSearch-div').layout('resize');
				}
		        children.$('#pInPatOrd').parent().height(children.$('#pInPatOrd').parent().parent().height()-children.$('#pInPatOrd').parent().prev().height()-5);
		        children.$('#pInPatOrd').width(children.$('#pInPatOrd').parent().width());
		        children.$('#pInPatOrd').height(children.$('#pInPatOrd').parent().height());
		        children.InPatOrdDataGrid.datagrid("resize");
		    },500);
        }
    });  
}
function InitTempFrame()
{
    var content="<iframe id='templateFrame' name='templateFrame' width='100%' height='100%' frameborder='0'></iframe>"
    if(ServerObj.TemplateRegion=='window'){
        $('<div id="templateWin"></div>').appendTo('#layoutMain').window({
			iconCls:'icon-w-list',
            title:'医嘱模板',
            minimizable:false,
            maximizable:false,
            closable:false,
            closed:false,
            modal:false,
            width:PageLogicObj.TempWidth,
            height:$(window).height()-150,
            content:content,
            onCollapse:function(){
                $(this).window('resize',{
                    width: 135
                }).window('move',{
                    top:$(window).height()-100,
                    left:$(window).width()-185
                });
            },
            onExpand:function(){
                $(this).window('resize',{
                    width: PageLogicObj.TempWidth
                }).window('move',{
                    top:100,
                    left:$(window).width()-PageLogicObj.TempWidth-30
                });
            }
        });
        if(ServerObj.DefCollapseTemp=='Y') $('#templateWin').window('collapse');
        else $('#templateWin').window('options').onExpand.call($('#templateWin')[0]);
    }else if(ServerObj.OrdListRegion==ServerObj.TemplateRegion){
        $('#tabOrdList').tabs('add',{
            title:'医嘱模板',
            selected:true,
            content:content,
	        onSelect:function(children){
	            setTimeout(function(){children.$('#tabFavCat').tabs("resize");},500);
	        }
        });
    }else{
        $('#layoutMain').layout('add',{
            region:ServerObj.TemplateRegion,
            border:false,
            collapsible:false,
            split:true,
            width:PageLogicObj.TempWidth,
            height:PageLogicObj.TempHeight,
            content:content,
            onResize:function(){
	        	ResetOrdListScale($(this).parent().outerHeight(),$(this).outerWidth(),ServerObj.TemplateRegion);
	        }
        });
    }
}
function InitOrdListLayout()
{
    if(!$('#tabOrdList').length) return;
    var tabs=$('#tabOrdList').tabs('tabs');
    if(tabs.length>1){
        $('#tabOrdList').tabs('select',ServerObj.DefaultExpendPage);
        setTimeout(renderTabHeader,1000);
        $('#pCenter').layout('panel',ServerObj.OrdListRegion).panel('options').onResize=function(){
            setTimeout(renderTabHeader,500);
        }
    }else{
        $('#tabOrdList').tabs('select',0);
    }
    function renderTabHeader(){
        $('#tabOrdList').children('.tabs-header').css({width:'156px',height:'30px',position:'absolute',top:'6px',right:'10px'}).children('.tabs-wrap').css({height:'30px'});
    }
}
function DisplayListTabHeader(display)
{
	if(!$('#tabOrdList').length) return;
	if(display) $('#tabOrdList').children('.tabs-header').show();
	else $('#tabOrdList').children('.tabs-header').hide();
}
function ResetOrdListScale(height,width,region)
{
	if(!window.event) return false;
	if(window.event.type.indexOf('mouse')==-1) return false;
	if(!width&&(['north','south'].indexOf(region)==-1)) return false;
	if(!PageLogicObj.resizeTimer) PageLogicObj.resizeTimer={};
	clearTimeout(PageLogicObj.resizeTimer[region]);
	PageLogicObj.resizeTimer[region]=setTimeout(function(){
		if(['north','south'].indexOf(region)>-1){
			var ConfigNode='TempHeightScale';
			var scale=Math.round(height/$('#layoutMain').height()*100);
		}else{
			var ConfigNode='TempWidthScale';
			var scale=Math.round(width/$('#layoutMain').width()*100);
		}
		$.cm({
			ClassName:"web.DHCDocConfig",
			MethodName:"SetUserPageScale",
			PageCode:"OrderEntry",Property:ConfigNode,Value:scale,
			dataType:'text'
		},function(){
			$.messager.popover({msg:'布局调整成功!',type:'success'});
			if(height) PageLogicObj.TempHeight=height;
			if(width) PageLogicObj.TempWidth=width;
		});
	},1000);
	return true;
}
function xhrRefreshFrame(obj)
{
    if(!obj.EpisodeID&&obj.adm) obj.EpisodeID=obj.adm;
    if(!obj.PatientID&&obj.papmi) obj.PatientID=obj.papmi;
	$.extend(paramObj,obj);
	for(var i=0;i<$('iframe').length;i++){
        if($('iframe').eq(i).attr('src')){
            var xhrRefresh=$('iframe')[i].contentWindow.xhrRefresh;
            if(xhrRefresh){
                xhrRefresh(paramObj);
            }else{
                var src=$('iframe').eq(i).attr('src');
                $('iframe').eq(i).attr('src',rewriteUrl(src,paramObj));
            }
        }else{
            var frame=$('iframe').eq(i).attr('id');
            var src=typeof urlCfgObj[frame]=='object'?urlCfgObj[frame][paramObj.CONTEXT]:urlCfgObj[frame];
            if(!src) continue;
            $('iframe').eq(i).attr('src',rewriteUrl(src,paramObj));
        }
	}
    ShowSecondeWin("onOpenDHCEMRbrowse");
    //history.pushState("", "", rewriteUrl(window.location.href,paramObj));
}
function urlToObj(url)
{
	var obj=new Object();
	var urlPara=url.split("?")[1];
	if(urlPara){
		var urlParaArray=urlPara.split("&");
		for(var i=0;i<urlParaArray.length;i++){
		    var oneUrlPara=urlParaArray[i];
		    var ParaName=oneUrlPara.split("=")[0];
		    var ParaValue=oneUrlPara.split("=")[1];
		    obj[ParaName] =ParaValue;
		}
	}
	if(!obj['CONTEXT']) obj['CONTEXT']="WNewOrderEntry";	//默认西药录入
	return obj;
}
//模版选择医嘱
function addSelectedFav(itemid,text,note,partInfo,callBackFun) {
	$("#z-q-container").hide();
	if (GlobalObj.warning != "") {
        $.messager.alert("警告",GlobalObj.warning);
        return false;
    }
    var ItemType=itemid.indexOf("||")>-1?'ARCIM':'ARCOS';
    var ProcNote=note||'';
    var OrderBodyPartLabel=partInfo||'';
	new Promise(function(resolve,rejected){
		if (ItemType =="ARCIM") {
			CheckDiagnose(itemid,resolve);
		}else{
			resolve(true);
		}
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) {
		        return false;
			}else{
				resolve();
			}
		});
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if (ItemType == "ARCIM") {
				GetItemDefaultRowId(itemid,resolve);
			}else{
				resolve();
			}
		});
	}).then(function(ItemDefaultRowId){
		return new Promise(function(resolve,rejected){
		    if (ItemType == "ARCIM") {
				var OrdParamsArr=new Array();
				OrdParamsArr.push({
					OrderARCIMRowid:itemid,
					ItemDefaultRowId:ItemDefaultRowId,
					OrderBodyPartLabel:OrderBodyPartLabel,
					OrderDepProcNote:ProcNote
				});
				new Promise(function(resolve,rejected){
					AddItemToList("",OrdParamsArr,"data","",resolve);
				}).then(function(RtnObj){
					var rowid=RtnObj.rowid;
					var returnValue=RtnObj.returnValue;
			        if (returnValue == false) {
			            //清空当前行
			            ClearRow(rowid);
			            if (callBackFun) callBackFun();
			            return;
			        }
					SetCellData(rowid, "OrdCateGoryRowId","");
					SetCellData(rowid, "OrdCateGory","");
					SetScreenSum();
					var OrderType=GetCellData(rowid,"OrderType");
			        CellFocusJumpAfterOrderName(rowid, OrderType);
			        if (callBackFun) callBackFun();
				})
		    }else{
		        //医嘱套
		        OSItemListOpen(itemid, text, "YES", "", "",callBackFun);
		        //添加数据成功后 设置Footer数据
			    SetScreenSum();
		    }
		 });
	})
}
//刷新模板
function refreshTemplate()
{
	return frames["templateFrame"].LoadTemplateData();
}
//模板编辑模式切换
function TemplateModeChange(mode)
{
    var width=mode?PageLogicObj.TempWidth:800;
    if(ServerObj.TemplateRegion=='window'){
        $('#templateWin').window('resize',{
            width: width
        }).window('move',{
            top:100,
            left:$(window).width()-width-10
        });
    }else if(['north','south'].indexOf(ServerObj.TemplateRegion)>-1){
    }else{
        $('#layoutMain').layout('panel',ServerObj.TemplateRegion).panel('resize',{width:width});
        $('#layoutMain').layout('resize');
        return;
    }
}
//医嘱列表另存为模板功能
function InsertMultFavItem(ItemArr)
{
	if(frames["templateFrame"].InsertMultItem(ItemArr)){
		//港大保存到医嘱模板时候自动保存用户常用 标版先注释
    	//SetSaveForUserClickHandler();	
	}
    return;
}
//医嘱录入界面医嘱类型切换调用
function OrderPriorChangeFun(OrderPriorItem,RefreshFlag)
{
    if ((frames["ordListFrame"]&&frames["ordListFrame"].ipdoc)&&((GlobalObj.isConnectOrderList=='Y')||RefreshFlag)){
        frames["ordListFrame"].ipdoc.patord.view.ReLoadGridDataFromOrdEntry(OrderPriorItem.type,'');
    }
}
//医嘱列表放大缩小
function Changebiggrid(flagbig)
{
    if(flagbig){
		$('#pCenter').layout('panel',ServerObj.OrdListRegion).panel('options').height=parseInt($(window).height())-15;
        //$('#pCenter').layout('panel',ServerObj.OrdListRegion).panel('resize',{height:$(window).height()});
    }else{
		$('#pCenter').layout('panel',ServerObj.OrdListRegion).panel('options').height=PageLogicObj.TempHeight;
        //$('#pCenter').layout('panel',ServerObj.OrdListRegion).panel('resize',{height:PageLogicObj.TempHeight});
    }
    $('#pCenter').layout('resize');
    var tab=$('#tabOrdList').tabs('getSelected')
	$('#tabOrdList').tabs('options').onSelect.call($('#tabOrdList')[0],tab.panel('options').title);
}
//医嘱录入放大缩小
function changeBigBtnClick(e)
{
	var text=$('#changeBigBtn').text().replace(/\s*/g,"");
	var newText=(text==$g('放大')?$g('缩小'):$g('放大'));
	var newHeight=(newText==$g('放大')?PageLogicObj.TempHeight:15);
	var layoutIDArr=['pCenter','layoutMain'],regionArr=['north','south'];
	for(var i=0;i<layoutIDArr.length;i++){
		var Find=false;
		for(var j=0;j<regionArr.length;j++){
			var panel=$('#'+layoutIDArr[i]).layout('panel',regionArr[j]);
			if(panel.length){
				Find=true;
				panel.panel('resize',{height:newHeight});
			}
		}
		if(Find) $('#'+layoutIDArr[i]).layout('resize');
	}
	ChangeBigButtonText();
}
function ChangeBigButtonText()
{
	setTimeout(function(){
		var newText=($(window).height()-$('#pOrder').height())>50?$g('放大'):$g('缩小');
		$('#changeBigBtn .l-btn-text,#changeBigBtn .menu-text').text(newText);
	},400);
}
function InitPrompt()
{
	$('#Prompt').tooltip({
		trackMouse:true,
		content:'',
		onShow:function(){
			var content=$(this).text();
			if(content==''){
				$(this).tooltip('tip').hide();
			}else{
				$(this).tooltip('tip').show();
				$(this).tooltip('update',content).tooltip('reposition');
			}
		}
	});
}
//放在InitPatOrderViewGlobal初始化患者信息中调用
function InitOrderPrior()
{
	$.cm({
		ClassName:'DHCDoc.Order.Common',
		MethodName:'GetOrderPriorJSON',
		EpisodeID:GlobalObj.EpisodeID, 
		LocID:session['LOGON.CTLOCID'], 
		UserID:session['LOGON.USERID'],
		GroupID:session['LOGON.GROUPID'],
		DefPriorType:$("#HiddenOrderPrior").val(),
		EmConsultItm:GlobalObj.EmConsultItm
	},function(OrderPriorData){
		var pOrderPriorWidth=0;
		if($('#kwOrderPrior').prop('tagName')=='DIV'){
			$("#kwOrderPrior").keywords({
				//oldValue:GlobalObj.DefaultOrderPriorRowid,
				singleSelect:true,
				labelCls:'red',
				items:OrderPriorData,
				onClick:function(item){
					var OrderPriorRowid=item.rowid;
					var opts=$("#kwOrderPrior").keywords('options');
					if(opts.oldValue==OrderPriorRowid) return;
					opts.oldValue=OrderPriorRowid;
					ChangeOrderPriorContrl(item);
				}
			}).keywords('switchById',$("#kwOrderPrior").keywords('getSelected')[0].id);
			if(GlobalObj.PAAdmType=="I"){
				switch(OrderPriorData.length){
					case 1:pOrderPriorWidth=0;break;
					case 2:pOrderPriorWidth=175;break;
					default:pOrderPriorWidth=260;break;
				}
			}
		}else{
			$("#kwOrderPrior").combobox({
				url:'',
				editable:false,
				panelHeight:'auto',
				valueField:'rowid',
				textField:'text',
				data:OrderPriorData,
				onSelect:function(item){
					ChangeOrderPriorContrl(item);
				},
				onLoadSuccess:function(data){
					for(var i=0;i<data.length;i++){
						if(data[i].selected){
							ChangeOrderPriorContrl(data[i]);
							break;
						}
					}
				}
			});
			$("#kwOrderPrior").combobox('textbox').focus(function(){
				$(this).blur();	//强制去除闪烁光标
			});
			$("#kwOrderPrior").combobox('panel').addClass('prior-combo-panel');
			if(GlobalObj.PAAdmType=="I") pOrderPriorWidth=110;
		}
		$('#pOrderPrior').panel('resize',{width:pOrderPriorWidth});
		if((GlobalObj.PAAdmType!="I")||(pOrderPriorWidth==0)) $('#pOrderPrior').hide();
		else $('#pOrderPrior').show();
		$('#layoutTipBar').layout('resize');
	});
}
//放在InitPatOrderViewGlobal初始化患者信息中调用
function InitButtonBar()
{
    $('#orderBtnList').marybtnbar({
		btnCls:'btn-toolbar',
        queryParams:{url:'oeorder.oplistcustom.new.csp'},
        onBeforeLoad:function(param){
	        param.EpisodeID=GlobalObj.EpisodeID;
        },
		loadFilter:function(data){
			if((['north','south'].indexOf(ServerObj.OrdListRegion)==-1)&&(['north','south'].indexOf(ServerObj.TemplateRegion)==-1)){
				for(var i=data.length-1;i>=0;i--){
					if((data[i].id=='changeBigBtn')){
						data.splice(i, 1); 
						break;
					}
				}
			}
			return data;
		},
        onLoadSuccess:function(){
	    	ChangeBigButtonText();
	    }
    });
}
function InitOrderEntryGrid(){
	//************************布局内容初始化--开始****************************//
	//var Order_DataGrid; //定义全局变量datagrid   
	//医嘱录入表格
	var url='oeorder.oplistcustom.new.request.csp?action=GetOrderList';
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	var mydata = [];		
	var lastSel;
	$("#Order_DataGrid").jqGrid({
		//data: mydata,
		//datatype: "local",
		url:url,
		datatype: "json",
		postData:{USERID:session['LOGON.USERID'],ADMID:GlobalObj.EpisodeID,NotDisplayNoPayOrd:GlobalObj.NotDisplayNoPayOrd},
		editurl:'clientArray',
		//height:'100%',
		//width:'100%',
		//autowidth:true,
		//autoheight:true,
		shrinkToFit: false,
		mtype:'POST',
		emptyrecords:$g('没有数据'),
		viewrecords:true,
		loadtext:$g('数据加载中...'),
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
			var OrderItemRowid=GetCellData(rowid,"OrderItemRowid");
			if(!GlobalObj.OPAllowDbClickStopOrd && OrderItemRowid != "" && OrderItemRowid != null && OrderItemRowid != undefined){
				return false;
			}
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
				var rowids = GetSelRowId();
				if (rowids.length<=0) { return; }
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
			/*if (typeof YLYYOnRightClick=="function"){
				YLYYOnRightClick(rowid);
			}*/
			if ((typeof Common_ControlObj=="object")&&(typeof Common_ControlObj.Interface=="function")) {
				Common_ControlObj.Interface("RightClick",{
					rowid:rowid
				});
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
				
				//CDSS回写医嘱
				if(typeof CDSSObj=='object') CDSSObj.AddOrdToList(GlobalObj.copyCDSSData);
				GlobalObj.copyCDSSData=[];
				//改变已经审核医嘱的颜色
				var rowids=$('#Order_DataGrid').getDataIDs();
				for(var i=0;i<rowids.length;i++){
					if(GetCellData(rowids[i], "OrderSignFlag")=='1'){
						var OrderName=GetCellData(rowids[i],"OrderName");
						$('#Order_DataGrid').setCell(rowids[i],"OrderName",OrderName,"OrderSigned","");
						InitRowBtn(rowids[i]);
					}else if(CheckIsItem(rowids[i])==true) {
						var OrderName=GetCellData(rowids[i],"OrderName");
						$('#Order_DataGrid').setCell(rowids[i],"OrderName",OrderName,"OrderSaved","");
						InitRowBtn(rowids[i]);
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
					InitDoseQtyToolTip(rowids[i]);
				}
				SetScreenSum();
				//护士执行-绑费用
				SetOrdNurseBindOrd();
			},200);
			//调整表格的宽度和高度,如出现医嘱审核按钮区浮动到表格行上方的情况,可放开此句
			//setTimeout(function (){ResizeGridWidthHeiht("resize");},1000);
		},
		resizeStop:function(newwidth, index){
			var col=ListConfigObj.colModel[index-1];
			if(col.name=="OrderOperatBtn"){
				$('#Order_DataGrid').find('td[aria-describedby=Order_DataGrid_OrderOperatBtn]').find('.shortcutbar-list-x').panel('resize');
			}else if(col.name=="OrderRecDep"){
				$('#Order_DataGrid').find('td[aria-describedby=Order_DataGrid_OrderRecDep]').find("input[id*='_OrderRecDep']").each(function(i,ele){
					//$(ele).combobox({width:parseInt($(ele).parent().width()* 0.98)});
					$(ele).combobox("resize", parseInt($(ele).parent().width()* 0.98));
				});
			}
		}
	});
	//双击列头事件
    jQuery('#Order_DataGrid').closest('.ui-jqgrid-view').find('div.ui-jqgrid-hdiv').bind("dblclick", headerDblClick);
    $('#Order_DataGrid').bind("drop", function(event) {
        console.log("禁止拖拽");return false;
    });

}