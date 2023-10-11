/// Creator:    bianshuai
/// CreateDate: 2014-09-09
/// Descript:   ��ҩ����[ҩʦ����]

//����Url
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">'+$g("[˫�������]")+'</span>';
var statusArr = [{ "val": "10", "text": $g("����") }, { "val": "20", "text": $g("����") },{ "val": "30", "text": $g("����") },{ "val": "40", "text": $g("ҩʦͬ��") }];
var appType="P";
//var medAdvID="";
//var Status="";  // qunianpeng 2016/10/17
$(function(){
	$("#StartDate").datebox("setValue", formatDate(-3));  //Init��ʼ����
	$("#EndDate").datebox("setValue", formatDate(0));     //Init��������
	
	$('#textarea').bind("focus",function(){
		if(this.value==$g("������...")){
			$('#textarea').val("");
		}
	});
	
	$('#textarea').bind("blur",function(){
		if(this.value==""){
			$('#textarea').val($g("������..."));
		}
	});
	
	$('div[name=list]').live("click",function(){    //E8F1FF
		$('#'+this.id).css('background','FFE48D').css('border','1px solid #CCC')
			.siblings().css("background","").css('border','');
		$('#medAdvDetID').html(this.id);
	})
	
	///����ƶ����뿪�¼�,������ɫ�仯 ttt Ϊ��ǰѡ�����
	$('div[name=list]').live('mouseover',function(){
		if(this.id!=$('#medAdvDetID').html()){
			$(this).css('background','E8F1FF');
		}
	}).live('mouseleave',function(){
		if(this.id!=$('#medAdvDetID').html()){
			$(this).css('background','');
		}
	})
	
	//״̬
	$('#status').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statusArr
	});
	
	//�ǼǺŰ󶨻س��¼�
    $('#patno').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        var patno=$('#patno').val();  //sufan  2016/09/13
			if(patno!=""){        //lbb  2020/1/13
	        getRegNo(patno);
            queryMedAdv(); //���ò�ѯ
			}
        }
    });
	
	InitPatList();     //��ʼ�������б�
	InitMedAdvList();  //��ʼ������ģ���б�
	
	$('#Find').bind("click",queryMedAdv);    //�����ѯ
//	$('a:contains("ɾ��")').bind("click",delMedAdv);    //ɾ������
	$('#DelMed').bind("click",delMedAdv);    //ɾ������   //qunianpeng 2016-08-17
	$('#Agr').bind("click",agrMedAdv);       //ͬ��
	$('#Quo').bind("click",createMedAdvWin); //����
	$('#App').bind("click",appMedAdvDetail); //����  //�ύ���
	$('#Del').bind("click",delMedAdvDetail); //ɾ��
	$('#Main').bind("click",medAdvTemp); //ģ��ά��
	
	queryMedAdv(); //ҳ���������Զ�����
	var p=$('#patList').datagrid('getPager');
	if(p){
		 $(p).pagination({ //���÷�ҳ������
		 			

	           //��ҳ���ܿ���ͨ��Pagination���¼����ú�̨��ҳ������ʵ��
				//showRefresh:false,
	        	onRefresh:function(){
		        	$('#medAdvCon').html("");
	        	}
	        });
	}
	
	
});

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:'medAdvTime',title:$g('ʱ��'),width:120},
		{field:'PatBed',title:$g('����'),width:60},
		{field:'PatNo',title:$g('�ǼǺ�'),width:80},
		{field:'PatName',title:$g('����'),width:80},
		{field:'CurStatus',title:$g('��ǰ״̬'),width:70},
		{field:'PatientID',title:'PatientID',width:80},
		{field:'AdmDr',title:'AdmDr',width:80},
		{field:'medAdvID',title:'medAdvID',width:80}
	]];
	
	//����datagrid
	$('#patList').datagrid({
		//title:'�����б�',    
		url:'',
		fit:true,
		//fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:30, 	    // ÿҳ��ʾ�ļ�¼����
		pageList:[30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		onClickRow:function(rowIndex, rowData){ 
			$('#medAdvDetID').html('');
			var EpisodeID=rowData.AdmDr;
			var PatientID=rowData.PatientID;
			Status=rowData.CurStatus;
			medAdvID=rowData.medAdvID;
			//LoadPatInfo(EpisodeID);  ///���ز��������Ҫ��Ϣ
			LoadMedAdvList(medAdvID);  ///������ϸ
		}
	});
	
	initScroll("#patList");//��ʼ����ʾ���������

}

/// ��ѯ
function queryMedAdv()
{
	var StDate=$('#StartDate').datebox('getValue'); //��ʼ����
	var EndDate=$('#EndDate').datebox('getValue');  //��ֹ����
	var patno=$('#patno').val();; 					//�ǼǺ�
	var status=$('#status').combobox('getValue');   //״̬
	if(typeof status=="undefined"){status="";}
	var params=StDate+"^"+EndDate+"^"+session['LOGON.USERID']+"^"+appType+"^"+status+"^^"+patno+"^"+session['LOGON.HOSPID'];
	$('#patList').datagrid({
		url:url+'?action=QueryMedAdvPatList',	
		queryParams:{
			params:params}
	});	
}
///�Զ���ȫ�ǼǺ�λ��   sufan 2016/09/13
function getRegNo(regno)
{
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	for (var i=1;i<=zerolen;i++)
	{regno="0"+regno
		}
	var patno=$('#patno').val(regno);
}
/// ɾ������
function delMedAdv()
{
	var row=$('#patList').datagrid('getSelected');
	if (row){
		var medAdvID=row.medAdvID;	//qunianpeng 2016/10/18
		var medAdvStatus=row.CurStatus; //hezhigang  2018-7-12
		 $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������",function(res){ //��ʾ�Ƿ�ɾ��
			 if (res) {
				$.post(url,{action:"delPatMedAdv",AdvID:medAdvID},function(data,status){
			       var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
			       if(retVal!="0"){
					if(medAdvStatus==$g("����")){
					  		$.messager.alert("��ʾ","ҽ���ѽ���,����ɾ����");
				       	}else  if(medAdvStatus==$g("����")){
					  		$.messager.alert("��ʾ","ҽ��������,����ɾ����");
				      	 }else  if(medAdvStatus==$g("ҩʦͬ��")){
					  		$.messager.alert("��ʾ","ҩʦ��ͬ����ҩ,����ɾ����");
				       }
			       }else{
				   //   medAdvID="";				//qunianpeng 2016/10/18
				   	  queryMedAdv();
					  $('#medAdvCon').html("");   //qunianpeng 2016-08-17
				   }
		       });
			 }
        });
	}
else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
function LoadMedAdvList(medAdvID)
{
	//��ȡ������Ϣ
 	 $.post(url,{action:"getPatMedAdvIn",AdvID:medAdvID},function(data,status){
	     var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
	     if(retVal!=""){
			InitMedAdivPanel(retVal);
	     }
     });
}

///���ؽ�����Ϣ
function InitMedAdivPanel(retVal)
{
	var htmlstr="";
	var medAdvDataArr=retVal.split("!");
	var AdvID=medAdvDataArr[0];             //RwoID
	var medAdvMasDateStr=medAdvDataArr[1];  //��ҩ��������Ϣ
	var medAdvDrgItmStr=medAdvDataArr[2];   //ҽ����Ϣ
	var medAdvContentStr=medAdvDataArr[3];  //������Ϣ
	
	//����Ϣ
	var medAdvMasArr=medAdvMasDateStr.split("^");
	htmlstr=htmlstr+"<div style='font-size:13pt;border-bottom: 2px solid #95B8E7;background: none repeat scroll 0% 0% #FFFFFF;padding: 10px 10px 15px 15px;position: relative;border-radius: 5px;box-shadow: 0px 3px 3px 0px #CCC inset;' id="+AdvID+" >";
	htmlstr=htmlstr+"<span style='font-weight:bold;'>"+$g('��Ч�ڣ�')+"</span><span>"+medAdvMasArr[0]+"</span><span style='font-weight:bold;margin-left:15px;margin-right:15px;'>"+$g('��')+"</span><span>"+medAdvMasArr[1]+"</span><span style='font-weight:bold;margin-left:30px;color:red;'>"+medAdvMasArr[2]+"</span>";
	htmlstr=htmlstr+"<br>";
	//ҽ��
	htmlstr=htmlstr+"<span style='font-weight:bold;'>"+$g('ԭҽ��:')+"</span>";
	htmlstr=htmlstr+"<br>";
	var medAdvDrgItmArr=medAdvDrgItmStr.split("||");
	for(var k=0;k<medAdvDrgItmArr.length;k++)
	{
		htmlstr=htmlstr+"<span style='margin-left:30px;'>"+medAdvDrgItmArr[k]+"</span>";
		htmlstr=htmlstr+"<br>";
	}
	//����
	var medAdvContentArr=medAdvContentStr.split("||");
	htmlstr=htmlstr+"<span style='font-weight:bold;'>"+$g('��ҩ����:')+"</span>";
	htmlstr=htmlstr+"<br>";
	for(var k=0;k<medAdvContentArr.length;k++)
	{
		var medAdvConArr=medAdvContentArr[k].split("^");
		htmlstr=htmlstr+"<div style='padding:5px;' name=list id="+medAdvConArr[4]+">";
		if(medAdvContentArr[k]!=""){
			htmlstr=htmlstr+"<span style='margin-left:30px;font-weight:bold;font-size:12pt;'>"+medAdvConArr[0]+":</span>";  //<span style='font-size:8pt;'>"+medAdvConArr[1]+" "+medAdvConArr[2]+"</span>
			htmlstr=htmlstr+"<br>";
			htmlstr=htmlstr+"<span style='margin-left:70px;font-size:12pt;'>"+medAdvConArr[3]+"</span>";
			htmlstr=htmlstr+"<br>";
		}
		htmlstr=htmlstr+"</div>";
	}
	//htmlstr=htmlstr+"<span style='margin-left:300px;font-weight:bold;'>ҩʦ��"+medAdvMasArr[3]+"</span><span style='margin-left:20px;font-weight:bold;'>"+medAdvMasArr[0]+"</span>"
	htmlstr=htmlstr+"</div>";
	
	$('#medAdvCon').html(htmlstr);
}

///������ҩ����
function appMedAdvDetail()
{
	var UserID=session['LOGON.USERID'];        ///�û�ID
	var medAdvDetailList=$('#textarea').val(); ///��ҩ����
	var row=$('#patList').datagrid('getSelected');	//qunianpeng 2016/10/18	
	if(!row){
		$.messager.alert("��ʾ","����ѡ������Ϣ��");
		return;
	}
	if((medAdvDetailList==$g("������..."))||(medAdvDetailList=="")){   //sufan 2016/09/09
		$.messager.alert("��ʾ","�����������,�ٽ����ύ��");
		return;
	}
	var medAdvID=row.medAdvID;
	//var curStatus="40";  //����״̬   ����ǿ  2016-09-12  //cancel annotate by qnp
	var curStatus="10";
	medAdvMasList=UserID+"^"+curStatus+"^"+medAdvDetailList.replace(/(^\s*)|(\s*$)/g,""); //ȥ����ʾ�ַ�

	var data=jQuery.param({"action":"SaveMedAdvDetail","AdvID":medAdvID,"dataList":medAdvMasList});
	$.ajax({
        type:"POST",
        url:url,
        data:data,
        dataType:"json",
        success: function (val) {
	    	LoadMedAdvList(medAdvID);  ///������ϸ
	    	$('#textarea').val("");    ///���textarea����
	    }
    });
}

///���ز�����ҩ�����б�
function LoadPatAdviceList()
{
	if (AdmDr==""){return;}
	$.post(url,{action:"getPatAdviceList",AdmDr:AdmDr},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!=""){
			var medAdvPatAdvArr=retVal.split("#");
			for(var m=0;m<medAdvPatAdvArr.length;m++){
				InitAdivisesPanel(medAdvPatAdvArr[m]); //��������
			}
		}
	});
}
/*  //qunianpeng 2016-08-17
/// ɾ����ҩ����
function delMedAdvDetail()
{
	var AdvID=$('#AdvID').html();  //��ȡ��ǰѡ����AdvID
	if (AdvID==""){
		$.messager.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼��");
		return;
	}
	$.post(url,{action:"delPatMedAdvDetail",AdvID:AdvID},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$('#'+AdvID).remove();
			$.messager.alert("��ʾ","ɾ���ɹ���");
		}else if(retVal=="-1"){
			$.messager.alert("��ʾ","���鲻���ڣ�");
		}else if(retVal=="-2"){
			$.messager.alert("��ʾ","ҽ���ѻظ�,����ɾ����");
		}else if(retVal=="-3"){
			$.messager.alert("��ʾ","��ҩʦ���飬����ɾ��");
			}
	});
}
*/
///��ʼ������ģ���б�
function InitMedAdvList()
{
		//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Code',title:$g('����'),width:100},
		{field:'Desc',title:$g('����'),width:600},
	]];
	
	//����datagrid
	$('#medAdvdg').datagrid({
		//title:'',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){
			var tmpDesc=rowData.Desc;
			if(($('#textarea').val()==$g("������..."))||($('#textarea').val()=="")){
				$('#textarea').val("").val(tmpDesc);
			}else{
				$('#textarea').val($('#textarea').val()+","+tmpDesc);
			}
			$('#medAdvWin').window('close');
		}
	});
	
	//initScroll();//��ʼ����ʾ���������
}

// �������ô���
function createMedAdvWin()
{	

	$('#medAdvWin').window({
		title:$g('�����б�')+titleNotes,    
		collapsible:true,
		border:true,
		closed:"true",
		width:800,
		height:350,
		minimizable:false
	});

	$('#medAdvWin').window('open');
	
	///�Զ����ؽ����ֵ�
	$('#medAdvdg').datagrid({
		url:url+'?action=QueryMedAdvTemp',	
		queryParams:{
			params:session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']
		}
	});
}

/// ɾ����ҩ������ϸ
function delMedAdvDetail()
{
	var medAdvDetID=$('#medAdvDetID').html();  //��ȡ��ǰѡ����AdvID
	if (medAdvDetID==""){
		$.messager.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼��");
		return;
	}
    if(Status==$g("����")){	//lbb   ҽ�����ߡ�ͬ�⡢���ܲ���ɾ��	 
		$.messager.alert("��ʾ","ҽ�������ߣ�����ɾ��");
		return;
	    } 
	else if(Status==$g("����")){		 
	    $.messager.alert("��ʾ","ҽ���ѽ��ܣ�����ɾ��");
		return;
	    } 
	else if(Status==$g("ҩʦͬ��")){		 
		$.messager.alert("��ʾ","ҩʦ��ͬ����ҩ������ɾ��");
		return;
		}
	$.post(url,{action:"delPatMedAdvDetail",medAdvDetID:medAdvDetID},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"&&(Status==$g("����"))){ //lbb  ����״̬����ɾ�� 
			$('#'+medAdvDetID).remove();
			$.messager.alert("��ʾ","ɾ���ɹ���");
			return;
		}else if(retVal=="-1"){
			$.messager.alert("��ʾ","���鲻���ڣ�");
			return;
		}else if(retVal=="-3"){
			$.messager.alert("��ʾ","��ҩʦ���飬����ɾ��");
			return;
			}
	});
}

/// ͬ��
function agrMedAdv()
{
	var row=$('#patList').datagrid('getSelected');	
	if(!row){
		$.messager.alert("��ʾ","��ѡ����������б����ݣ�");
		return;
	}
	var medAdvID=row.medAdvID;
	if(Status!=$g("����")){		//��״̬Ϊ����ʱ��ҩʦ���ɲ���ͬ�ⰴť qunianpeng 2016/10/17 
		$.messager.alert("��ʾ","ҽ��δ���ߣ����ɲ�����");
		return;
	} 
	var curStatus="40";  //ҩʦͬ��Ϊ40
	$.post(url,{action:"agrPatMedAdv",medAdvID:medAdvID,curStatus:curStatus},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$.messager.alert("��ʾ","�����ɹ���");
			queryMedAdv();      //sufan 2016/09/12
			LoadMedAdvList(medAdvID);
		}else{
			$.messager.alert("��ʾ","����ʧ�ܣ�");
		}
	});
}

/// ��ҩ����ģ��ά��
function medAdvTemp()
{
	$('#medAdvTempWin').window({
		title:$g('��ҩ����ģ��ά��'),    
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:500,
		minimizable:false
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.medadvtemp.csp"></iframe>';
	$('#medAdvTempWin').html(iframe);
	$('#medAdvTempWin').window('open');
}
