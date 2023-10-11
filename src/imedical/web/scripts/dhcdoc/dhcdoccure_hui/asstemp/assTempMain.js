//===========================================================================================
// 作者：      nk
// 编写日期:   2021-07-26
// 描述:	   assTempMain.js
//===========================================================================================
var PageLogicObj={
	AssTempApplyListDataGrid:"",
	SavedAssTempArr:[]
}
$(function(){
	Init();
	InitEvent();
})

/// 页面初始化函数
function Init(){
	InitAssListDataGrid();     /// 初始化列表
	if(ServerObj.EpisodeID!=""){
		//加载患者信息条
		if(typeof InitPatInfoBanner){
			InitPatInfoBanner(ServerObj.EpisodeID); 
		}
	}else{
		$(".PatInfoItem").text("请选择需评估患者...")	
	}
}

function InitEvent(){
	//togglePanelExpand();
}

function togglePanelExpand(){
	var wp = $("#CenterPanel").layout("panel", "west");
	var cp = $("#CenterPanel").layout("panel", "center");
	$(wp).panel({
		onExpand:function(){
			IFrameReSizeWidth("FormMain",-300)
		},
		onCollapse:function(){
			IFrameReSizeWidth("FormMain",300)
		}	
	})	
}

function InitAssListDataGrid(){
	var columns=[[
		{field:'AssTempLabel',title:'评估模板名称',width:200,align:'left',
			formatter:function(value,row,index){
				if($.hisui.indexOfArray(PageLogicObj.SavedAssTempArr,row.AssTempID)>-1){
					var htmlstr =  '<div class="SavedAssTemp">&nbsp;&nbsp;&nbsp;&nbsp;'+ value+'</div>';
					return htmlstr;
				}else{
					return value;
				}
			}
		},
		{field:'AssTempID',title:'AssTempID',width:100,hidden:true},
		{field:'DCRowIDStr',title:'DCRowIDStr',width:20,hidden:true}
	]];
	var dgObj={
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.Assessment&QueryName=QryAssTempList",
		loadMsg : '加载中..',  
		pagination : false,  
		pageSize : 20,
		pageList : [10,20],
		rownumbers : true, 
		idField:"AssTempID",
		columns :columns,
		onBeforeLoad:function(param){
		},onLoadSuccess:function(data){
		    ///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
		},
		onBeforeSelect: function (rowIndex, rowData) {
			$("#AssDiffList,#AssSameList").datagrid("clearSelections");
        },onSelect:function(rowIndex, rowData){
        	reloadForm(rowData.AssTempID,rowData.DCRowIDStr);
		}
	}
	
	$HUI.datagrid("#AssSameList",$.extend(dgObj,{
		onBeforeLoad:function(param){
			var SessionExpID=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+ServerObj.LgHospID;
			var sDesc=$("#SDesc").searchbox("getValue");
			$.extend(param,{Flag:"Same",DCRowIDStr:ServerObj.DCRowIDStr,sDesc:sDesc});
		}
	}));
	if(ServerObj.CureLocUseAssTemp=="N"){
		$HUI.datagrid("#AssDiffList",$.extend(dgObj,{
			fitColumns : false,
			columns :[[
				{field:'AssTempLabel',title:'评估模板名称',width:200,align:'left',
					formatter:function(value,row,index){
						if($.hisui.indexOfArray(PageLogicObj.SavedAssTempArr,row.AssTempID)>-1){
							var htmlstr =  '<div class="SavedAssTemp">'+ value+'</div>';
							return htmlstr;
						}else{
							return value;
						}
					}
				},
				{field:'ArcimDesc',title:'对应治疗医嘱项',width:220,
					formatter: function(value,row,index){
						var myvalue="'"+value+"'"
						return '<a class="editcls-Desc" id= "' + row["ID"] + '"onmouseover="ShowDescDetail(this,'+myvalue+')">'+value+'</a>';
					}
				},
				{field:'AssTempID',title:'AssTempID',width:100,hidden:true},
				{field:'DCRowIDStr',title:'DCRowIDStr',width:20,hidden:true}
			]],
			onBeforeLoad:function(param){
				var sDesc=$("#SDesc").searchbox("getValue");
				$.extend(param,{Flag:"Diff",DCRowIDStr:ServerObj.DCRowIDStr,sDesc:sDesc});
			}
		}));
	}
}

function AssListDataGridLoad(){
	$HUI.datagrid("#AssSameList").reload();
	if(ServerObj.CureLocUseAssTemp=="N"){
		$HUI.datagrid("#AssDiffList").reload();
	}
}

function InvAssTempCallBack(AssTempID){
	if($.hisui.indexOfArray(PageLogicObj.SavedAssTempArr,AssTempID)<0){
		$.hisui.addArrayItem(PageLogicObj.SavedAssTempArr,AssTempID);
	}
	var rows=$HUI.datagrid("#AssSameList").getSelected();
	if(rows){
		$HUI.datagrid("#AssSameList").reload();
	}else{
		var rows=$HUI.datagrid("#AssDiffList").getSelected();
		if(rows){
			$HUI.datagrid("#AssDiffList").reload();
		}
	}
}

function reloadForm(AssTempID,DCRowIDStr){
	if($(".tool-msg").length>0){
		$(".tool-msg").remove();	
	}
	if(AssTempID==0){
		var LinkUrl = "doccure.cureassessment.hui.csp?EpisodeID="+ServerObj.EpisodeID+"&DCRowIdStr="+DCRowIDStr+"&PageShowFromWay="+ServerObj.PageShowFromWay;
	}else{
		var LinkUrl = "doccure.asstemp.hui.csp?DCAdmID="+ServerObj.EpisodeID+"&DCAssTempID="+AssTempID+"&DCRowIDStr="+DCRowIDStr+"&PageShowFromWay="+ServerObj.PageShowFromWay;
	}
	if(typeof websys_writeMWToken=='function') LinkUrl=websys_writeMWToken(LinkUrl);
	$("#FormMain").attr("src", LinkUrl);	
}

function ShowDescDetail(that,content){
	var contentFlag=0; //为0 代表显示的是医嘱列信息 为1代表无论长度都要显示
	if ((contentFlag==0)&&($(that).width()<160)) return false;
	var MaxHeight=20;
	MaxHeight='auto',placement="top";
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

//iframe宽度自适应
function IFrameReSizeWidth(iframename,width) {
	var pTar = document.getElementById(iframename);
	if (pTar) { //ff
		if (pTar.contentDocument && pTar.contentDocument.body.offsetWidth) {
			pTar.width = pTar.contentDocument.body.offsetWidth+width;
		} //ie
		else if (pTar.Document && pTar.Document.body.scrollWidth) {
			pTar.width = pTar.Document.body.scrollWidth+width;
		}
	}
}