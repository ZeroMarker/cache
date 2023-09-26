var OrdTemplTee;
var argobj={
	"UserID":session['LOGON.USERID'],"GroupID":session['LOGON.GROUPID'],
	"LocID":session['LOGON.CTLOCID'],"CONTEXT":"W50007",
	"objectType":"User.SSUser","HospID":session['LOGON.HOSPID'],
	"Region":session['LOGON.REGION'],"SITECODE":session['LOGON.SITECODE'],
	"EpisodeID":ServerObj.EpisodeID
};
var treeData;
function Init(){
	LoadOrdEntryiFrame(ServerObj.CONTEXT); //  W50007
	InitOrdTemplTree();
   $("#OrdTemplMan").click(OrdTemplManClick);
}
function LoadOrdEntryiFrame(iFrameName){
	var Url=window.location.href;
	var UrlArr=Url.split("?");
	$('#OrdEntryWin').empty();
	var lnk="";
	if(iFrameName=="WNewOrderEntry"){
		argobj.CONTEXT="WNewOrderEntry";
		var src="oeorder.oplistcustom.new.csp?"+UrlArr[1]; //PatientID="+ServerObj.PatientID+"&EpisodeID="+ServerObj.EpisodeID
	}else{
		argobj.CONTEXT="W50007";
		var src="opdoc.oeorder.cmlistcustom.csp?"+UrlArr[1]; //PatientID="+ServerObj.PatientID+"&EpisodeID="+ServerObj.EpisodeID
	}
	ServerObj.CONTEXT=iFrameName;
	var ordEntry= '<iframe name="OrdEntryFrame" id="frameOrdEntry" src="'+src+'" width="100%" height="100%"'+
                     'marginheight="0" marginwidth="0" scrolling="no" align="middle" ></iframe>';
    $('#OrdEntryWin').append(ordEntry);
}

var dw=$(window).width()-166,dh=$(window).height()-50;
function OrdTemplManClick(){
	if (ServerObj.CONTEXT=="WNewOrderEntry"){
		var CMFlag="";
	}else{
		var CMFlag="CM";
	}
	var src="oeorder.template.maintenancev8.csp?EpisodeID="
			+ServerObj.EpisodeID+"&XCONTEXT="+ServerObj.CONTEXT
			+"&PreftabType=User.SSUser&SaveContextWorkflow=on&CMFlag="+CMFlag;
	websys_showModal({
		url:src,
		title:'医嘱模板维护',
		width:$(window).width()-50,height:$(window).height()-50,
		onClose: function() {
			InitOrdTemplTree();
		}
	});
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
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
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function ClearTree(){
    var tbox=$HUI.tree("#OrdTemplTree");
    var roots=tbox.getRoots();
    for (var i=roots.length-1;i>=0;i--){
	  var node = tbox.find(roots[i].id);
	  tbox.remove(node.target);
    }
}
function ClearNameTabs(){
	$("#mmedit div").remove();
	var _$tab=$('#templName_tabs');
	var tabs=_$tab.tabs('tabs');
	for (var i=tabs.length-1;i>=0;i--){
		_$tab.tabs('close',i);
	}
}
function destroyDialog(id){
	$("body").remove("#"+id); //移除存在的Dialog
	$("#"+id).dialog('destroy');
}
function getCheckedNodes(){
	var nodeArr=new Array();
	var nodes = $("#OrdTemplTree").tree('getChecked');
	for (var i=0;i<nodes.length;i++){
		var eleid=nodes[i]['value'];
		if (eleid=="") continue;
		nodeArr.push(eleid.replace(/\^/g,String.fromCharCode(4)));
	}
	return nodeArr;
}
function unCheckedNodes(){
	var nodes = $("#OrdTemplTree").tree('getChecked');
	for (var i=0;i<nodes.length;i++){
		var id=nodes[i]['id'];
		if (id=="") continue;
		var node = $('#OrdTemplTree').tree('find', id);
		
		$("#OrdTemplTree").tree('uncheck',node.target);
	}
}
function GetOrdTempTypeTabSel(){
	var v=$("#OrdTempTypeKW").keywords('getSelected');
	return "User."+v[0].id;
}
function CardBillAfterReload(){
	$("#frameOrdEntry")[0].contentWindow.CardBillAfterReload(); 
}
function menuHandler(item){
	var tab = $('#templName_tabs').tabs('getSelected');
	if (tab){
		$('#templName_tabs').tabs('unselect',$('#templName_tabs').tabs('getTabIndex',tab));
	}
	templNameTabSelect(+item['id']-1);
}

function xhrRefresh(obj){
	var OrdEntryWin=$('#OrdEntryWin').find("iframe").get(0);
	var curNewIframe=window.frames[OrdEntryWin.name];
	if (typeof curNewIframe.xhrRefresh =="function"){
		$.extend(ServerObj,{PatientID:obj.papmi,EpisodeID:obj.adm,mradm:obj.mradm});
		$.extend(argobj,{EpisodeID:obj.adm});
		LoadOrdTemplTree()
		curNewIframe.xhrRefresh(obj);
	}else{
		var Url=window.location.href;
		Url=rewriteUrl(Url, {
			EpisodeID:obj.adm,
			PatientID:obj.papmi,
			mradm:obj.mradm});
		history.pushState("", "", Url);
		window.location.reload();
		return;
	}
}
function onBeforeCloseTab(){
	var OrdEntryWin=$('#OrdEntryWin').find("iframe").get(0);
	var curNewIframe=window.frames[OrdEntryWin.name];
	if (typeof curNewIframe.DocumentUnloadHandler =="function"){
		curNewIframe.DocumentUnloadHandler();
	}
	return true;
}
/*window.onbeforeunload = DocumentUnloadHandler;
function DocumentUnloadHandler(){
	var OrdEntryWin=$('#OrdEntryWin').find("iframe").get(0);
	var curNewIframe=window.frames[OrdEntryWin.name];
	if (typeof curNewIframe.DocumentUnloadHandler =="function"){
		curNewIframe.DocumentUnloadHandler();
	}
}*/
function InitOrdTemplTree(){
	InitTree();
	$("#OrdTempTypeKW").keywords({
	    singleSelect:true,
	    items:[
		        {text:'个人',id:'SSUser',selected:false},
		        {text:'科室',id:'CTLoc',selected:false}
		    ],
	    onClick:function(v){
		    LoadTemplNameTab();
		}
	});
    //模板名切换
    $('#templName_tabs').tabs({    
	    onSelect:function(title,index){
		    templNameTabSelect(index);
	    }    
    }); 
    LoadOrdTemplTree();
    $("#TemplateDetail").dialog('expand');
}
function InitTree(){
	$("#OrdTemplTree").parent().css("height",$(window).height()-95)
	var tbox=$HUI.tree("#OrdTemplTree",{
		checkbox:true,
		onlyLeafCheck:true,
		onDblClick:function(node){
			var value=node.value.replace(/\^/g,String.fromCharCode(4));
			if ((value=="")||(value==undefined)) return false;
			OrdEntryFrame.window.addSelectedFav(value);
		},
		formatter:function(node){
			if (node.eleid=="") return node.text;
			else {
				if (+node.RealStock=="0"){
					return '<span style="color:red">'+node.text+'</span>';
				}else{
					return node.text;
				}
			}
		},
		onClick: function(node){
			var isLeaf=$(this).tree('isLeaf',node.target)
			if (!isLeaf){
				$(this).tree('toggle',node.target)
			}else{
				var curId=$(this).tree('getNode',node.target).id;
				var isChecked=false;
				var nodes = $(this).tree('getChecked');
				for (var i=0;i<nodes.length;i++){
					if (nodes[i]['id']==curId){
						$(this).tree('uncheck',node.target);
						isChecked=true;
						break;
					}
				}
				if (!isChecked){
					$(this).tree('check',node.target);
				}
			}
		},
		onBeforeCheck:function(node, checked){
			var isLeaf=$(this).tree('isLeaf',node.target);
			if (isLeaf){
				var eleid=node.value;
				if (eleid=="") return false;
				var type=eleid.split(String.fromCharCode(4))[0];
				if (type=="ARCIM"){
					$(this).tree('select',node.target);
				}else{
					return false;
				}
			}else{
				return false;
			}
		}
	});
}
function LoadOrdTemplTree(){
	$.cm({
	    ClassName:"DHCDoc.OPDoc.OrderTemplateCommmon",
	    MethodName:"GetOEPrefTabsTreesJson",
		EpisodeID:ServerObj.EpisodeID,
		XCONTEXT:ServerObj.CONTEXT,
		LocID:session['LOGON.CTLOCID'], 
	    UserID:session['LOGON.USERID']
	},function(jsonData){
		treeData=jsonData;
		var kwSelId="SSUser";
		if (jsonData["User.SSUser"].length==0) kwSelId="CTLoc";
		$("#OrdTempTypeKW").keywords("select",kwSelId);
		LoadTemplNameTab();
	})
}
function LoadTemplNameTab(){
	$("#BMore,#templName_tabs").show();
	ClearTree();
	ClearNameTabs();
	var kwsel=$("#OrdTempTypeKW").keywords('getSelected');
	var ObjectType="User."+kwsel[0].id;
	var treeShowData=treeData[ObjectType];
	var LasTabNameIndex=-1,showMoreBtnFlag=0;
	var _$scroller=$("#templName_tabs .tabs-scroller-left");
	for (var i=0;i<treeShowData.length;i++){
		var id=treeShowData[i]["id"];
		var name=treeShowData[i]["text"];
		var pId=treeShowData[i]["pId"];
		if (pId==0){
			if ((_$scroller.is(':hidden'))&&(showMoreBtnFlag==0)){
				$('#templName_tabs').tabs('add',{
					title: name,
					index: id,
					selected: i==0
				});
				LasTabNameIndex=LasTabNameIndex+1;
				if (!_$scroller.is(':hidden')){
					AddMoreMenu();
				}
			}else{
				AddMoreMenu();
			}
		}
	}
	if (showMoreBtnFlag==0){
		$("#BMore").hide();
	}
	function AddMoreMenu(){
		showMoreBtnFlag=1;
		if (LasTabNameIndex>-1){
			var closeTab=$('#templName_tabs').tabs('getTab',LasTabNameIndex);
			var closeTabTitle=closeTab.panel("options").title;
			var closeTabid=closeTab.panel("options").index;
			$("#mmedit").menu('appendItem', {
				id:closeTabid,
				text: closeTabTitle
			});
			$('#templName_tabs').tabs('close',LasTabNameIndex);
			LasTabNameIndex=-1;
		}else{
			$("#mmedit").menu('appendItem', {
				id:id,
				text: name
			});
		}
	}
}
function templNameTabSelect(index){
	var kwsel=$("#OrdTempTypeKW").keywords('getSelected');
	var ObjectType="User."+kwsel[0].id;
	var data=treeData[ObjectType][index]["children"];
	var treeDataArr=new Array();
	for (var i=0;i<data.length;i++){
		var id=data[i]["id"];
		var name=data[i]["text"];
		var children=data[i]["children"];
		var state=(i==0)?"open":"closed";   
		treeDataArr.push({"id":id,"text":name,"state":state,"children":children});
	}
	$("#OrdTemplTree").tree("loadData",treeDataArr)
}