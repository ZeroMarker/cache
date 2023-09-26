/*
ģ��:		�ƶ�ҩ��
��ģ��:		�ƶ�ҩ��-����ҩ�����б�
Creator:	hulihua
CreateDate:	2016-10-07
*/

$(function(){
	/* ��ʼ����� start*/
	//ʱ����ʾ
	beginrefresh();
	setInterval("beginrefresh()",1000);
	
    //��ʼ�����棬����������
    InitWardSeatPage(); 
    /* ��ʼ����� end*/
    
    /* �󶨰�ť�¼� start*/
    AutoRefresh();
    
	$("#btn_set").on("click",function(){
		$("#modal-windowset").modal('show');
		$("#modal-windowset").draggable();	//ʵ�ִ��ڵ��ƶ�
		InitWardSeatSet();
	});
    /* �󶨰�ť�¼� end*/
    if(window.screen) {
	    window.moveTo(0, 0);          
    	window.resizeTo(screen.availWidth, screen.availHeight);   
    }
     
    var wscript = new ActiveXObject("WScript.Shell"); 
    wscript.SendKeys("{F11}");  
})

//���ú�̨��ȡ��һ�����õ�����������ÿ�
function InitWardSeatSet() {
	runClassMethod("web.DHCINPHA.MTWardSeat.SetWardConfig","SelAllWardSeatInfo",
	{'params':gGroupId+"^"+gLocId+"^"+gUserID},
	function(data){ 
		var seatSize = data.size;
		var row = seatSize.split("*")[0];
		var col = seatSize.split("*")[1];
		$('#sel-row').val(row);
		$('#sel-col').val(col);
	});	
}

function InitWardSeatPage() {
	//���÷���ִ�к�̨����
	runClassMethod("web.DHCINPHA.MTWardSeat.SetWardConfig","SelAllWardSeatInfo",
	{'params':gGroupId+"^"+gLocId+"^"+gUserID},
	function(data){ 
		var seatSize = data.size;
		var row = seatSize.split("*")[0];
		var col = seatSize.split("*")[1];
		var str = data.text;
		initWardSeat(row,col);  			//��ʼ������
		initWardSeatText(row,col,str,"0");  //��������ʾ������	
	});	
}

//��ʱˢ�²����б��������ֵ
function AutoRefresh(){
	runClassMethod("web.DHCINPHA.MTWardSeat.SetWardConfig","SelAllWardSeatInfo",
	{'params':gGroupId+"^"+gLocId+"^"+gUserID},
	function(data){ 
		var seatRefreshTime = data.refreshtime;
		var RefreshTime=parseInt(seatRefreshTime*1000);
		setInterval("RefreshWardSeat()",RefreshTime);
	});	
}

function RefreshWardSeat() {
	runClassMethod("web.DHCINPHA.MTWardSeat.SetWardConfig","SelAllWardSeatInfo",
	{'params':gGroupId+"^"+gLocId+"^"+gUserID},
	function(data){
		var seatSize = data.size;
		var row = seatSize.split("*")[0];
		var col = seatSize.split("*")[1];
		var str = data.text;
		initWardSeatText(row,col,str,"1");  
	});	
}

//��ʼ����
function initWardSeat(row,col){
	var a=($(window).width()-40)/col;    	//�����б�Ŀ�
	var b=($(window).height()-10)/row;    	//�����б�ĸ�
	var $BedDiv  = $('#lef-bottom');
	for (i = 1; i <= row*col; i++) {
		$("<div class='sickbed' style='visibility:false;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;margin:2px;float:left;border:2px solid #C1C1C1;width:"+a+"px;height:"+b+"px;border-radius:3px;' id='sickbed" +i+"'>" +
			"<div class='seattitle' style='height:"+(b-120)+"px;line-height:"+(b-120)+"px;text-align:center;margin-bottom:0px;margin-left:0px;background-color:#AEAEAE;' id='seattitle"+i+"'></div>"+
			"<div style='clear: both'></div>" +
			"<div class='patientBody' id='patientBody"+i+"'>"+
				"<div style='width:100%' >"+
					"<div style='float:left;width:50%;height:55px;text-align:center;line-height:35px;border-right:1px solid #C1C1C1;font-size:32px;' id='songyao"+i+"'></div>" +
					"<div style='float:right;width:50%;height:55px;text-align:center;line-height:35px;font-size:32px;' id='quyao"+i+"'></div>" +
				"</div>"+
				"<div style='width:100%' >"+
					"<div style='float:left;width:50%;height:60px;text-align:center;line-height:35px;border-top:1px solid #C1C1C1;border-right:1px solid #C1C1C1;font-size:32px;' id='duma"+i+"'></div>"+
					"<div style='float:right;width:50%;height:60px;text-align:center;line-height:35px;border-top:1px solid #C1C1C1;font-size:32px;' id='jingshen"+i+"'></div>"+
				"</div>"+
			"</div>"+
		"</div>").appendTo($BedDiv); 
		
		if(i%col==0&&i!=col*row){
			$("<div style='clear:both'></div>").appendTo($BedDiv); 
		}
	}	
	$("<div style='clear: both'></div>").appendTo($BedDiv); //�������
	if(col=="6"){
		$('.sickbed').css('width','16.2%');
	}
	else if(col=="5"){
		$('.sickbed').css('width','16.5%');
	}
	else if(col=="4"){
		$('.sickbed').css('width','16.5%');
	}
	else if(col=="3"){
		$('.sickbed').css('width','16.5%');
	}
	else if(col=="2"){
		$('.sickbed').css('width','16.5%');
	}
	else if(col=="1"){
		$('.sickbed').css('width','16.5%');
	}
	else{
		$('.sickbed').css('width',a+'px');
		//var bodyWidth=145*col+"px";
		//$('body').css({'width':bodyWidth,'overflow-x':'auto'})
	}	
}

///�����б�����ʾ����
///WardCode_"^"_WardDesc_"^"_WardLoc_"^"_WardId
function initWardSeatText(row,cow,str,type){
	var strArr = str.split("$$");
	var num=0
	for(i=0;i<strArr.length-1;i++){
		var seatWardCode=strArr[i].split("^")[1];	//��������
		var seatWardDesc=strArr[i].split("^")[2];	//��������
		var seatWardLoc=strArr[i].split("^")[3];	//����LocID
		var seatWardId=strArr[i].split("^")[4];		//����ID
		var SendDrugNum=strArr[i].split("^")[5];	//��ҩ���쵥����
		var TakeDrugNum=strArr[i].split("^")[6];	//ȡҩ���쵥����
		var ToxAnesDrugNum=strArr[i].split("^")[7];	//�������쵥����
		var PsychoDrugNum=strArr[i].split("^")[8];	//�������쵥����
		var AuditConFlag=strArr[i].split("^")[9];	//��ҩ���ȷ�ϱ�־
		var num=num+1;	
		//��䲡���������������ı䱳��ɫ��
		//$(".sickbed #seattitle"+num).append('&nbsp;&nbsp;<span style="font-family:�����п�; font-size:30px; color:#000000;">'+seatWardCode+'</span>'); 
		if(type=="0"){
			$(".sickbed #seattitle"+num).append('&nbsp;&nbsp;<span style="font-family:΢���ź�; font-size:36px; font-weight:bold; color:#000000;">'+seatWardCode+'</span>'); 
			$("#sickbed"+num).css('visibility','visible');
		}	

		//����������ɫ�Ŀ���
		if(AuditConFlag=="1"){
			$("#seattitle"+num).css("background-color","#F36D6A");
		}else{
			$("#seattitle"+num).css("background-color","#AEAEAE");
		}
		 
		//������Ϊ0��ȫ����Ϊ�գ�
		if(SendDrugNum=="0"){
			SendDrugNum="";
		}
		if(TakeDrugNum=="0"){
			TakeDrugNum="";
		}
		if(ToxAnesDrugNum=="0"){
			ToxAnesDrugNum="";
		}
		if(PsychoDrugNum=="0"){
			PsychoDrugNum="";
		}
		//�����쵥�������ڽ���λ�ò����Ʊ���ɫ��
		$(".sickbed #songyao"+num).text(SendDrugNum);
		if(SendDrugNum!=""){
			$("#songyao"+num).css("color","#F88C7C");
		}
		$(".sickbed #quyao"+num).text(TakeDrugNum);
		if(TakeDrugNum!=""){
			$("#quyao"+num).css("color","#64BF01");
		}
		$(".sickbed #duma"+num).text(ToxAnesDrugNum);
		if(ToxAnesDrugNum!=""){
			$("#duma"+num).css("color","#582F78");
		}
		$(".sickbed #jingshen"+num).text(PsychoDrugNum);
		if(PsychoDrugNum!=""){
			$("#jingshen"+num).css("color","#FFB400");
		}
		
		//����Ҫ���뵽���������ֵ��
		$(".sickbed #seattitle"+num).attr("seatWardLoc",seatWardLoc);
		$(".sickbed #seattitle"+num).attr("seatWardCode",seatWardCode);	
		$(".sickbed #seattitle"+num).attr("SendDrugNum",SendDrugNum);
		$(".sickbed #seattitle"+num).attr("TakeDrugNum",TakeDrugNum);
		$(".sickbed #seattitle"+num).attr("ToxAnesDrugNum",ToxAnesDrugNum);
		$(".sickbed #seattitle"+num).attr("PsychoDrugNum",PsychoDrugNum);
		
		//���쵥�б�
		InitGirdReqDispList();
	}
	 
	//�л�ѡ����ʽ��
	$('.sickbed').unbind("click"); 
	$('.sickbed').click(function(){
		$(".sickbed-selected").each(function(){
			$(this).removeClass("sickbed-selected")	
		})
		$(this).addClass("sickbed-selected");
		//�����������쵥�б��ڣ�
		ShowWinReq();			
		return false;		
	});	
}

//������ʾʱ�䣬1s��ˢ��һ��
function beginrefresh(){
	var time=new Date();
	var y=time.getFullYear(); //��ȡ��
	var m=time.getMonth()+1; //��ȡ��
	var d=time.getDate(); //��ȡ��
	var h=time.getHours(); //��ȡСʱ
	var M=time.getMinutes(); //��ȡ��
	var s=time.getSeconds(); //��ȡ��
	m=coverPosition(m.toString(),2,"0");
	d=coverPosition(d.toString(),2,"0");
	h=coverPosition(h.toString(),2,"0");
	M=coverPosition(M.toString(),2,"0");
	s=coverPosition(s.toString(),2,"0");
	var str="";
	var week = time.getDay(); 
	if (week == 0) {  
        str = "������";  
	} else if (week == 1) {  
        str = "����һ";  
	} else if (week == 2) {  
        str = "���ڶ�";  
	} else if (week == 3) {  
        str = "������";  
	} else if (week == 4) {  
        str = "������";  
	} else if (week == 5) {  
        str = "������";  
	} else if (week == 6) {  
        str = "������";  
	} 	
	//���ڸ�ʽ������
	var timestr = "";
	runClassMethod("web.DHCINPHA.MTCommon.CommonUtil","DateFormat", 
			{},
			function(data){
				if(data==3){
					timestr = y+"-"+m+"-"+d+" "+h+":"+M+"";
			    }else if(data==4){
				    timestr = d+"/"+m+"/"+y+" "+h+":"+M+"";
				}else{
					return ;
				}
					var showtimestr= timestr+"&nbsp&nbsp&nbsp&nbsp"+str;
				  	$("#showNowTime").html(showtimestr);	
	});			
}

function ShowWinReq(){
	var $obj=$(".sickbed-selected").find(".seattitle");
	var SendDrugFlag = ($obj.attr("SendDrugNum")==""||$obj.attr("SendDrugNum")==undefined)?"":$obj.attr("SendDrugNum");
	var TakeDrugFlag = ($obj.attr("TakeDrugNum")==""||$obj.attr("TakeDrugNum")==undefined)?"":$obj.attr("TakeDrugNum");
	var ToxAnesDrugFlag = ($obj.attr("ToxAnesDrugNum")==""||$obj.attr("ToxAnesDrugNum")==undefined)?"":$obj.attr("ToxAnesDrugNum");
	var PsychoDrugFlag = ($obj.attr("PsychoDrugNum")==""||$obj.attr("PsychoDrugNum")==undefined)?"":$obj.attr("PsychoDrugNum");
	if((SendDrugFlag=="")&&(TakeDrugFlag=="")&&(ToxAnesDrugFlag=="")&&(PsychoDrugFlag=="")){
		CleanModel();
		RefreshWardSeat();
		dhcphaMsgBox.alert("�ף���ѡ��Ĳ���û�����쵥Ŷ!") ;
		$("#modal-windowinreqlist").modal('show');
		return false;
	}else{
		$("#modal-windowinreqlist").modal('show');
		$("#modal-windowinreqlist").draggable();	//ʵ�ִ��ڵ��ƶ�
    	$("#modal-windowinreqlist").css("overflow", "hidden"); // ��ֹ���ֹ����������ֵĻ������ѹ�����һ�������ߵ�
	}
	
	//��ʼ�����ڿؼ�
    var opt = {
        preset: 'date', 		//����
        //theme: 'android', 		//Ƥ����ʽ
        display: 'bubble', 		//��ʾ��ʽ 
        //mode: 'clickpick', 		//����ѡ��ģʽ
        dateFormat: 'yy-mm-dd', // ���ڸ�ʽ
        setText: 'ȷ��', 		//ȷ�ϰ�ť����
        cancelText: 'ȡ��',		//ȡ����ť����
        dateOrder: 'yymmdd', 	//������������и�ʽ
        dayText: '��', 
        monthText: '��', 
        yearText: '��', 		//���������������
        endYear:2100 			//�������
    }; 
    $('#startdate').mobiscroll(opt);
    $('#enddate').mobiscroll(opt);
	
	//�����ڿؼ�����ʼ��ֵ��
	var configstr=tkMakeServerCall("web.DHCSTPHALOC","GetPhaflag",gLocId);
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	startdate=FormatDateYMD(startdate);
	enddate=FormatDateYMD(enddate);
	$('#startdate').val(startdate);
	$('#enddate').val(enddate);
	
	//��Ӳ������⣡
	var WardCode = ($obj.attr("seatWardCode")==""||$obj.attr("seatWardCode")==undefined)?"":$obj.attr("seatWardCode");
	$('#title-ward').text(WardCode);
	
	//���Ƶ����Ŀ��Ƿ���Ա༭ѡ��Ĺ���
	if(SendDrugFlag==""){
		$('#chk-senddrug').iCheck('disable')
	}else{
    	$('#chk-senddrug').iCheck('enable');
    } 
	if(TakeDrugFlag==""){
		$('#chk-takedrug').iCheck('disable');
	}else{
    	$('#chk-takedrug').iCheck('enable');
    }
	if(ToxAnesDrugFlag==""){
		$('#chk-toxanesdrug').iCheck('disable');
	}else{
    	$('#chk-toxanesdrug').iCheck('enable');
    }
	if(PsychoDrugFlag==""){
		$('#chk-psychodrug').iCheck('disable');
	}else{
    	$('#chk-psychodrug').iCheck('enable');
    }

	//�����쵥�б�ֵ��
	QueryReqDispList();
}

//��ʼ�����쵥�б�table
function InitGirdReqDispList(){
	var columns=[
		{header:'ID',index:'TPhRid',name:'TPhRid',hidden:true},
		{header:'���쵥��',index:'TInphReqNo',name:'TInphReqNo',width:230,align:'left',
			formatter:function(cellvalue, options, rowObject){
			    return "<a onclick=\"ShowInphReqNoItemWindow("+rowObject.TPhRid+")\" style='text-decoration:underline;'>"+cellvalue+"</a>";
			}
		},
		{header:'��������',index:'TInphReqType',name:'TInphReqType',width:60,align:'left'}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTWardSeat.GetReqDispQuery&MethodName=GetInPhReqNoList',		
	    height: 350,
	    multiselect: false,
	    //autowidth: true,
	    shrinkToFit: true,
	    gridComplete:function(){
    		$(this).parents(".ui-jqgrid-bdiv").css("overflow-x","hidden");
	    }
	};
	
	$("#grid-reqsenddrug").dhcphaJqGrid(jqOptions);
	$("#grid-reqtakedrug").dhcphaJqGrid(jqOptions);
	$("#grid-reqtoxanesdrug").dhcphaJqGrid(jqOptions);
	$("#grid-reqpsychodrug").dhcphaJqGrid(jqOptions);
}

//���쵥��ϸ��Ϣ����
function ShowInphReqNoItemWindow(inphReqId){
	var columns=[
		{header:'ҩƷ����',index:'TArcimDesc',name:'TArcimDesc',align:'left'},
	    {header:'������',index:'TPrescno',name:'TPrescno'},
		{header:'��������',index:'TDspQty',name:'TDspQty'},
		{header:'��λ',index:'TDspUom',name:'TDspUom'},
		{header:'�ǼǺ�',index:'TPatNo',name:'TPatNo'},
		{header:'��������',index:'TPatName',name:'TPatName'},
		{header:'����',index:'TBedNo',name:'TBedNo'},
		{header:'Ҫ��ִ��ʱ��',index:'TDspDate',name:'TDspDate'}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url: LINK_CSP+'?ClassName=web.DHCINPHA.MTWardSeat.GetReqDispQuery&MethodName=GetInPhReqItemById', //��ѯ��̨
	    height: '120%',
	    autowidth:true,
	    datatype:'local'
	};
	$("#grid-inphreqitem").dhcphaJqGrid(jqOptions);
	$("#modal-getinphreqitem").on('shown.bs.modal', function () {
		$("#grid-inphreqitem").setGridWidth($("#modal-getinphreqitem .modal-body").width())
		$("#grid-inphreqitem").HideJqGridScroll({hideType:"X"});		
	});
	$("#grid-inphreqitem").setGridParam({
		datatype:'json',
		page:1,
		postData:{
			params:inphReqId
		}
	}).trigger("reloadGrid")
	$('#modal-getinphreqitem').modal('show');
	$("#modal-getinphreqitem").draggable();	//ʵ�ִ��ڵ��ƶ�
    $("#modal-getinphreqitem").css("overflow", "hidden"); // ��ֹ���ֹ����������ֵĻ������ѹ�����һ�������ߵ�
}

//�رյ������쵥��ϸ����
function CloseReqItem(){
	$('#modal-getinphreqitem').modal('hide');
}

//�رյ����������쵥����
function CloseReqListWin(){
	CleanModel();
	$('#modal-windowinreqlist').modal('hide');
	RefreshWardSeat();
}
 
//���ȷ�Ϲ̻����쵥��ӡ��ǩ
function ConfSoliInPhReq(){
	//���ж��ĸ����͵Ĺ��Ƿ�������һ����
	if ($('#chk-senddrug').is(':checked')||$('#chk-takedrug').is(':checked')||$('#chk-toxanesdrug').is(':checked')||$('#chk-psychodrug').is(':checked')){	
		//����Ѿ�ѡ�е����͵����쵥����
		var phridstr1="";phridstr2="";
		if($('#chk-senddrug').is(':checked')){
			var senddrugphridstr=GetInPhReqNoStr("#grid-reqsenddrug");
			phridstr1=senddrugphridstr;
		}
		if($('#chk-takedrug').is(':checked')){
			var takedrugphridstr=GetInPhReqNoStr("#grid-reqtakedrug");
			phridstr2=takedrugphridstr;
		}
		if($('#chk-toxanesdrug').is(':checked')){
			var toxanesdrugphridstr=GetInPhReqNoStr("#grid-reqtoxanesdrug");
			if(phridstr2==""){
				phridstr2=toxanesdrugphridstr;
			}else{
				phridstr2=phridstr2+"^"+toxanesdrugphridstr;
			}
		}
		if($('#chk-psychodrug').is(':checked')){
			var psychodrugphridstr=GetInPhReqNoStr("#grid-reqpsychodrug");
			if(phridstr2==""){
				phridstr2=psychodrugphridstr;
			}else{
				phridstr2=phridstr2+"^"+psychodrugphridstr;
			}
		}
		if((phridstr1=="")&&(phridstr2=="")){
			dhcphaMsgBox.alert("����ѡ������Ŀǰû�ж�Ӧ�����쵥�����ʵ!") ;
			return;
		}
		var phridstr=phridstr1+"#"+phridstr2;
		var PrintInPhReqConNoStr=TempSaveInPhReq(phridstr);
		
		PrintInPhReqLabel(PrintInPhReqConNoStr);
		CloseReqListWin();
		
	}else{
		dhcphaMsgBox.alert("��û��ѡ�����쵥���ͣ����ʵ!") ;
		return;
	}
}

//��̨�̻����󵥲����ع̻��Ĺ�������
function TempSaveInPhReq(phridstr){
	var InPhReqConNoStr=tkMakeServerCall("web.DHCINPHA.MTWardSeat.GetReqDispQuery","SaveInPhReqTmpConNo",phridstr)
	if(InPhReqConNoStr==""){
		dhcphaMsgBox.alert("�̻����쵥ʧ�ܣ����ʵ!") ;
		return;
	}else{
		return InPhReqConNoStr;
	}
}

//��ӡ�̻����쵥�ı�ǩ
function  PrintInPhReqLabel(PrintConNoStr){
	var PrintConNoStrArr = PrintConNoStr.split("$$");
	for(j=0;j<PrintConNoStrArr.length;j++){
		var InPhReqConNo=PrintConNoStrArr[j];
		var PrintInfoStr=tkMakeServerCall("web.DHCINPHA.MTWardSeat.GetReqDispQuery","GetPrintLabelInfo",InPhReqConNo,gLocId);
		if(PrintInfoStr==""){
			continue;
		}else{
			PrintInPhLabel(PrintInfoStr,InPhReqConNo);
		}		
	}
}

//��ȡ��������ʾ�����쵥�ĵ��Ŵ���
function GetInPhReqNoStr(grid){
	var tmpphridstr="";
	var dispgridrows=$(grid).getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$(grid).jqGrid('getRowData',i)
		var tmpphrid=tmpselecteddata["TPhRid"];
		if(tmpphridstr==""){
			tmpphridstr=tmpphrid;
		}else{
			tmpphridstr=tmpphridstr+"^"+tmpphrid;
		}
	}
	return tmpphridstr;
}
 
//�ر����ô���
function CloseSeatSetWin(){
	$('#modal-windowset').modal('hide');
}

//���쵥��ѯ
function QueryReqDispList(){
	var startdate=$("#startdate").val();
	var enddate=$("#enddate").val();	
	var $obj=$(".sickbed-selected").find(".seattitle");
	var wardlocid = ($obj.attr("seatWardLoc")==""||$obj.attr("seatWardLoc")==undefined)?"":$obj.attr("seatWardLoc");
	
	var inphreqtypestr="1^2^3^4";
	var gridstr="#grid-reqsenddrug&#grid-reqtakedrug&#grid-reqtoxanesdrug&#grid-reqpsychodrug"
	var strlen = inphreqtypestr.split("^");
	for(i=0;i<strlen.length;i++){
		var inphreqtype=inphreqtypestr.split("^")[i];
		var grid=gridstr.split("&")[i];
		
		var params=startdate+"^"+enddate+"^"+gLocId+"^"+wardlocid+"^"+inphreqtype;
		
		$(grid).setGridParam({
			datatype:'json',
			postData:{
				'params':params
			}
		}).trigger("reloadGrid");
		
	}		 	 
}

//������������
function SaveSeatSetData(){
	var seltime=$("#sel-time").val();
	var selcustomtime=$("#sel-customtime").val();
	var selrow=$("#sel-row").val();
	var selcol=$("#sel-col").val();
	var refreshtime=seltime;
	if(refreshtime==""){
		refreshtime=selcustomtime;	
	}
	var InPut=selrow+"*"+selcol+"^"+refreshtime;
	var retval=tkMakeServerCall("web.DHCINPHA.MTWardSeat.SetWardConfig","SaveSetWardSeat",InPut,gLocId);
	if(retval=="0"){
		dhcphaMsgBox.alert("���óɹ���");
		CloseSeatSetWin();
		$('#lef-bottom div.sickbed').remove();	
	}
	InitWardSeatPage();
}

function CleanModel(){	
	$('#seatWardLoc').val("") ;    
	$('#seatWardCode').val("");
	$('#title-ward').text("");
	$('#chk-senddrug').iCheck('uncheck');
	$('#chk-takedrug').iCheck('uncheck');
	$('#chk-toxanesdrug').iCheck('uncheck');
	$('#chk-psychodrug').iCheck('uncheck');
	$("#grid-reqsenddrug").clearJqGrid();
	$("#grid-reqtakedrug").clearJqGrid();
	$("#grid-reqtoxanesdrug").clearJqGrid();
	$("#grid-reqpsychodrug").clearJqGrid();
}  
