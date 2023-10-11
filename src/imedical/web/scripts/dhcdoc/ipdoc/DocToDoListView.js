$(function(){
	LoadInDocToDo();
});
///��ʼ��ҽ�ƴ�����
function LoadInDocToDo(){
	if (typeof ServerObj.InDocToDoDataGrid!="undefined") ServerObj.InDocToDoDataGrid.datagrid("loading");
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
	$.cm({
	    ClassName:"web.DHCDocToDoView",
	    MethodName:"GetDocToDoList",
		EpisodeID:ServerObj.EpisodeID,
		QueryDate:ServerObj.QueryDate,
		SessionStr:SessionStr
	},function(jsonData){
		LoadInDocToDoData(jsonData);
		InitOtherIcon();
		ServerObj.InDocToDoDataGrid.datagrid("loaded");
	})
	function LoadInDocToDoData(jsonData){
		var Columns=jsonData[0].Columns;
		var RowsData=jsonData[0].rows;
		if (typeof ServerObj.InDocToDoDataGrid=="undefined"){
			//��һ�γ�ʼ������Ҫ��ʼ����񼰱���ͷ
			var TableWidth=$("#tabInDocToDo").parent().width()-20;
			var CouWitdh=parseInt(TableWidth/Columns.length);
			
			var InDocToDoProperty=GetDefalutInDocToDoProperty();
			for (var i=0;i<Columns.length;i++){
				$.extend(Columns[i],{width:CouWitdh,align:'center'});
			}
			$.extend(InDocToDoProperty,{columns:[Columns]});
			ServerObj.InDocToDoDataGrid=$("#tabInDocToDo").datagrid(InDocToDoProperty);
		}else{
			//ֻ��Ҫ�޸ı�ͷ���ݼ���
			for (var i=0;i<Columns.length;i++){
				var field=Columns[i].field;
				var title=Columns[i].title;
				if (title==""){continue}
				$(".datagrid-header-row>td[field=\""+field+"\"]").find("span:first").html(title);
			}
		}
		$(".datagrid-header-row>td[field]").each(function (){
			var titleText=$(this).find("span:first").html();
			if (titleText.indexOf(ServerObj.CurrDate)>=0){
				$(this).css('background-color','#BEF4E8');
			}else{
				$(this).css('background-color','');
			}
		});
		ServerObj.InDocToDoDataGrid.datagrid("loadData",RowsData);
	}
}
function GetDefalutInDocToDoProperty(){
	
	var InDocToDoProperty={
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		resizable:false,
		autoRowHeight : true,
		rownumbers:false,
		pagination : false,  //
		rownumbers : false,  //
		toolbar:[],
		idField:'Date_0'
	};
	$.extend(InDocToDoProperty,{loadFilter:DocToolsHUI.lib.pagerFilter});
	return InDocToDoProperty;
	
}
//��ʼ��һЩ����ͼ������
function InitOtherIcon(){
	if ((typeof ServerObj.InitOtherIconFlag!="undefined")&&(ServerObj.InitOtherIconFlag==true)){
		return
	}
	//���б��
	var FirstCellDIV=$(".tabInDocToDo-header-row0 td:first div");
	FirstCellDIV.append("<div class='Bias' style='height:"+FirstCellDIV.outerWidth()+"px;'></div>")
	.append("<div class='TableTips'><span>"+$g("ʱ��")+"</span><span style='left:"+parseInt(FirstCellDIV.outerWidth()-60)+"px;'>"+$g("����")+"</span></div>")
	
	
	var HeadTDList=$(".datagrid-header-row").find("td");
	for (var i=0;i<HeadTDList.length;i++){
		//ȡ����ͷ����긡���¼�
		$(HeadTDList[i]).unbind("mouseenter.datagrid");
		//���ڶ������һ�������л���ͼ��
		if (i==1){
			$(HeadTDList[i]).children("DIV:first").prepend("<a class='QueryLeft icon-black-left' onClick=\"QueryTODO('Left')\"></a>")
		}
		
		//�����һ�����һ�������л���ͼ��
		if (i==(HeadTDList.length-1)){
			$(HeadTDList[i]).children("DIV:first").append("<a class='QueryRight icon-black-right' onClick=\"QueryTODO('Right')\"></a>")
		}
	}

	$.extend(ServerObj,{InitOtherIconFlag:true});
}
//�����л�����ʱ�����в�ѯ����
function QueryTODO(Type){
	if (Type=="Left"){
		ServerObj.QueryDate=GetNewDate(ServerObj.QueryDate,-7);
	}else if (Type=="Right"){
		ServerObj.QueryDate=GetNewDate(ServerObj.QueryDate,7);
	}
	LoadInDocToDo()
}
function GetNewDate(QueryDate,Num){
	var DateObj=DateStringToDateObj(QueryDate);
	var NewDateObj = new Date(DateObj);
	NewDateObj.setDate(parseInt(DateObj.getDate())+parseInt(Num));
	return ReWriteDate(NewDateObj.getDate(),NewDateObj.getMonth()+1,NewDateObj.getFullYear())
	
	
}

function ReWriteDate(d,m,y) {
	y=parseInt(y,10);
	if (y<15) y+=2000; else if (y<100) y+=1900;
	if ((y>99)&&(y<1000)) y+=1900;
	if ((d<10)&&(String(d).length<2)) d='0'+d;
	if ((m<10)&&(String(m).length<2)) m='0'+m;
	var newdate='';
	if (dtformat=="YMD"){
	 newdate=y+'-'+m+'-'+d;
	}
	if (dtformat=="DMY"){
	 newdate=d+'/'+m+'/'+y;
	}
	//newdate=d+'/'+m+'/'+y;
 	return newdate;
}
function xhrRefresh(refreshArgs)
{
    var adm=refreshArgs.adm;
	if (ServerObj.EpisodeID==adm){
		LoadInDocToDo();
		return true;
	}
	if (typeof ServerObj.InDocToDoDataGrid!="undefined") ServerObj.InDocToDoDataGrid.datagrid("loading");
	$.extend(ServerObj,{EpisodeID:adm});
	var QueryDate=$.cm({
	    ClassName:"web.DHCDocToDoView",
	    MethodName:"GetDefaultQueryDate",
		EpisodeID:ServerObj.EpisodeID,
		dataType:"text"
	},false)
	if (typeof(history.pushState) === 'function') {
        var Url=window.location.href;
        Url=rewriteUrl(Url, {
	        EpisodeID:refreshArgs.adm,
        	PatientID:refreshArgs.papmi,
        	mradm:refreshArgs.mradm,
        	forceRefresh:refreshArgs.forceRefresh
        });
        history.pushState("", "", Url);
    }
    $.extend(ServerObj,{QueryDate:QueryDate});
    LoadInDocToDo();
}

function showModal(lnk){
	websys_showModal({
		url:lnk,
		iconCls: 'icon-w-paper',
		title:$g('ҽ�ƴ���'),
		width:'95%',height:'80%',
		closable:true,
		CallBackFunc:function(result){
			
		},onClose:function(){
			LoadInDocToDo();
		}
	})
}
function closeDoListModel() {
	///alert(1111)
}
function OpenOrdEntryMene(){
	/*
	var warning=$.cm({
	    ClassName:"web.DHCDocToDoView",
	    MethodName:"GetDocToDoList",
		EpisodeID:ServerObj.EpisodeID,
		dataType:"text"
	},false)
	if (warning!="") return;*/
	if (typeof parent.switchTabByEMR =="function"){
		//parent.switchTabByEMR("dhc_side_oe_oerecord");
		parent.switchTabByEMR($g("ҽ��¼��"));
	}else if (typeof parent.parent.switchTabByEMR =="function"){
		parent.parent.switchTabByEMR($g("ҽ��¼��"));
	}
}
