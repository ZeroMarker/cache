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
	//��ʼ����������LookUp
    InitChronicDiagLookUp();
    //��ʼ��ҽ��
    InitLogonDocStr();
    //����ӿڳ�ʼ��
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
	            //���ûѡ���ҳǩ,ҽΪ������������ݺ�������ʾ����,��Ҫresizeһ��
	            var $body=tab.panel('body');
	            if($body.children('iframe').attr('src')&&$body.children('iframe')[0].contentWindow.$){
	            	onSelect.call(tab[0],$body.children('iframe')[0].contentWindow);
		        }
            }
        }
    }).tabs('add',{
        title:'ҽ���б�',
        selected:true,
        content:"<iframe id='ordListFrame' name='ordListFrame' width='100%' height='100%' frameborder='0'></iframe>",
        onSelect:function(children){
	        setTimeout(function(){	
	        	//ҽ���б���沼�ֺ�����Ҫ�Ż�
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
            title:'ҽ��ģ��',
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
            title:'ҽ��ģ��',
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
			$.messager.popover({msg:'���ֵ����ɹ�!',type:'success'});
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
	if(!obj['CONTEXT']) obj['CONTEXT']="WNewOrderEntry";	//Ĭ����ҩ¼��
	return obj;
}
//ģ��ѡ��ҽ��
function addSelectedFav(itemid,text,note,partInfo,callBackFun) {
	$("#z-q-container").hide();
	if (GlobalObj.warning != "") {
        $.messager.alert("����",GlobalObj.warning);
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
			            //��յ�ǰ��
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
		        //ҽ����
		        OSItemListOpen(itemid, text, "YES", "", "",callBackFun);
		        //������ݳɹ��� ����Footer����
			    SetScreenSum();
		    }
		 });
	})
}
//ˢ��ģ��
function refreshTemplate()
{
	return frames["templateFrame"].LoadTemplateData();
}
//ģ��༭ģʽ�л�
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
//ҽ���б����Ϊģ�幦��
function InsertMultFavItem(ItemArr)
{
	if(frames["templateFrame"].InsertMultItem(ItemArr)){
		//�۴󱣴浽ҽ��ģ��ʱ���Զ������û����� �����ע��
    	//SetSaveForUserClickHandler();	
	}
    return;
}
//ҽ��¼�����ҽ�������л�����
function OrderPriorChangeFun(OrderPriorItem,RefreshFlag)
{
    if ((frames["ordListFrame"]&&frames["ordListFrame"].ipdoc)&&((GlobalObj.isConnectOrderList=='Y')||RefreshFlag)){
        frames["ordListFrame"].ipdoc.patord.view.ReLoadGridDataFromOrdEntry(OrderPriorItem.type,'');
    }
}
//ҽ���б�Ŵ���С
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
//ҽ��¼��Ŵ���С
function changeBigBtnClick(e)
{
	var text=$('#changeBigBtn').text().replace(/\s*/g,"");
	var newText=(text==$g('�Ŵ�')?$g('��С'):$g('�Ŵ�'));
	var newHeight=(newText==$g('�Ŵ�')?PageLogicObj.TempHeight:15);
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
		var newText=($(window).height()-$('#pOrder').height())>50?$g('�Ŵ�'):$g('��С');
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
//����InitPatOrderViewGlobal��ʼ��������Ϣ�е���
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
				$(this).blur();	//ǿ��ȥ����˸���
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
//����InitPatOrderViewGlobal��ʼ��������Ϣ�е���
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
	//************************�������ݳ�ʼ��--��ʼ****************************//
	//var Order_DataGrid; //����ȫ�ֱ���datagrid   
	//ҽ��¼����
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
		emptyrecords:$g('û������'),
		viewrecords:true,
		loadtext:$g('���ݼ�����...'),
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
				
				//CDSS��дҽ��
				if(typeof CDSSObj=='object') CDSSObj.AddOrdToList(GlobalObj.copyCDSSData);
				GlobalObj.copyCDSSData=[];
				//�ı��Ѿ����ҽ������ɫ
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
					InitDoseQtyToolTip(rowids[i]);
				}
				SetScreenSum();
				//��ʿִ��-�����
				SetOrdNurseBindOrd();
			},200);
			//�������Ŀ�Ⱥ͸߶�,�����ҽ����˰�ť��������������Ϸ������,�ɷſ��˾�
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
	//˫����ͷ�¼�
    jQuery('#Order_DataGrid').closest('.ui-jqgrid-view').find('div.ui-jqgrid-hdiv').bind("dblclick", headerDblClick);
    $('#Order_DataGrid').bind("drop", function(event) {
        console.log("��ֹ��ק");return false;
    });

}