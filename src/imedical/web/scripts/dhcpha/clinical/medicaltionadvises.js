/// Creator:bianshuai
/// CreateDate:014-09-09
/// Descript:��ҩ������д����
var url='dhcpha.clinical.action.csp' ;
var AdmDr="";
var AppType="";
var orditm=""
$(function(){
	AdmDr=getParam("EpisodeID");
	AppType=getParam("AppType");
	ORditm=getParam("ORditm");
	InitPatInfo(); 			//��ʼ�����˻�����Ϣ
	InitPatMedGrid();  		//��ʼ��������ҩ�б�
	//AutoLoadMedInfo(AdmDr); //���ز���ҽ����Ϣ
	LoadPatAdviceList();
	InitMedAdvList();  		//��ʼ������ģ���б�
	
	$('div[name=list]').live("click",function(){
		$('#'+this.id).css('background','#ADFAFC').siblings().css("background","");
		$('#AdvID').html(this.id);
	})
	
	$('#textarea').bind("focus",function(){
		if(this.value=="�����뽨����Ϣ..."){
			$('#textarea').val("");
		}
	});
	
	$('#textarea').bind("blur",function(){
		if(this.value==""){
			$('#textarea').val("�����뽨����Ϣ...");
		}
	});
	
	$('#Quote').bind("click",createSuggestWin);     //����ģ��
	$('#Sure').bind("click",sureAddMedAdvDetail);   //ȷ��
	$('#Del').bind("click",delMedAdvDetail);        //ɾ��
	$('#Main').bind("click",medAdvTemp); //ģ��ά��
	$("#Btn_Lab").bind("click", function(){  //���ü���
	 	 createLabDetailView(qouteLabResult);
	 });
	
	$('#textarea').css({width:'99%'})
});
function qouteLabResult(addTxt){
	 var text = $("#textarea").val();
	 $('#textarea').val("");
	 if(text=="�����뽨����Ϣ...") {
		 $("#textarea").val(addTxt);
	 }else{
		 $("#textarea").val(text +" "+ addTxt);
	 }
} 

//������ҩ��Ϣ
function AutoLoadMedInfo(AdmDr)
{
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOrdItmInfo',	
		queryParams:{
			params:AdmDr}
	});
}

//���˻�����Ϣ��
//���ػ�����Ϣ
//nisijia 2016-09-22
function InitPatInfo()
{
	$.ajax({ 
        type: "POST", 
        url: 'dhcpha.clinical.action.csp', 
        data: "action=GetPatEssInfo&EpisodeID="+AdmDr, 
        error: function (XMLHttpRequest, textStatus, errorThrown){
        }, 
        success: function (data){
	        var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
	        if(retVal!=""){
            	SetPatientInfo(retVal);
	        }
        } 
        
    });
}

//���û�����Ϣ
//nisijia  2016-09-22
function SetPatientInfo(patientInfo) {
	var adrRepObj = jQuery.parseJSON(patientInfo);	
	var splitor = '&nbsp&nbsp|&nbsp&nbsp';
	var htmlStr = '&nbsp<span class="spancolorleft">�ǼǺ�:</span> <span class="spancolor">'
			+ adrRepObj.medicalNo + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">����:</span><span class="spancolor">'
			+ adrRepObj.admbed + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">����:</span> <span class="spancolor">'
			+ adrRepObj.patname + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">�Ա�:</span> <span class="spancolor">'
			+ adrRepObj.patsex + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">����:</span> <span class="spancolor">'
			+ adrRepObj.patage + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">���ѷ�ʽ:</span><span class="spancolor">'
			+ adrRepObj.paytype + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">��Ժ����:</span> <span class="spancolor">'
			+ adrRepObj.admdate + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">���:</span> <span class="spancolor">'
			+ adrRepObj.patdiag + '</span>';
	$('#patInfo').append(htmlStr);
	jQuery(".patInfo").css("display", "inline-block");
	jQuery(".tool-disease").css("display", "block");
}

//��ʼ��������ҩ�б�
function InitPatMedGrid()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"moeori",title:'moeori',width:90,hidden:true},
		{field:'Pri',title:'���ȼ�',width:60},
		{field:"orditm",title:'ҽ��ID',width:90,hidden:true},
		{field:'MedName',title:'����',width:200},
		{field:'StartDate',title:'��ʼ����',width:80},
		{field:'EndDate',title:'��������',width:80},
		{field:'Dosage',title:'����',width:80},
		{field:'Instance',title:'�÷�',width:80},
		{field:'freq',title:'Ƶ��',width:80},
		{field:'duration',title:'�Ƴ�',width:80},
		{field:'Doctor',title:'ҽ��',width:80},
		{field:'OeFlag',title:'OeFlag',width:80,hidden:true},
		{field:'doctorID',title:'doctorID',width:80,hidden:true},
		{field:'execStat',title:'�Ƿ�ִ��',width:80},		/// ����ִ�кͷ�ҩ qunianpeng 2018/3/12
		{field:'sendStat',title:'�Ƿ�ҩ',width:80},
		{field:'orderbak',title:'ҽ����ע',width:80}

	]];
	var allFlag = $("#chk-all").is(':checked');
	//����datagrid
	$('#medInfo').datagrid({
		//title:'ҽ����Ϣ�б�', 
		url:url+'?action=GetPatOrdItmInfoNew&AdmDr='+AdmDr+"&AppType=''&AllFlag="+allFlag,
		fit:true,
		//fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,           // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onLoadSuccess:function(){
			var items = $('#medInfo').datagrid('getRows');
			$.each(items, function(index, item){
				if(item.moeori==ORditm){
					$('#medInfo').datagrid('selectRow',index);
				}
				else{
						$('#medInfo').datagrid('unselectRow',index);
					}
				});
		},
		rowStyler:function(index,row){
			if ((row.OeFlag=="D")||(row.OeFlag=="C")){
				return 'background-color:pink;';
			}
		},
		onClickRow:function(rowIndex, rowData){
			var flag=0;
			///��ȡ��ǰ���Ƿ�ѡ��
			if($('tr[datagrid-row-index='+rowIndex+']').hasClass('datagrid-row-checked')){
				var flag=1;
			}

			///һ��ҽ��ͬʱѡ��
			var items = $('#medInfo').datagrid('getRows');
			$.each(items, function(index, item){
				if(item.moeori==rowData.moeori){
					if(flag==1){
						$('#medInfo').datagrid('selectRow',index);
					}else{
						$('#medInfo').datagrid('unselectRow',index);
					}
				}
			})
		}
	});
	
	initScroll();//��ʼ����ʾ���������
	$('#medInfo').datagrid('loadData',{total:0,rows:[]});
}

// ����TextArea
function addOrdInfo()
{
	var d=$('#medInfo').datagrid("getData");
	var detail=d.rows;
	var doctorID="";
	$('#ordstr').html("");	
	var ordstr=[];
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems=="")    //qunianpeng 2016-09-08
	{
		$.messager.alert('������ʾ',"��ѡ��ҽ����");
		return;		
	}
    $.each(checkedItems, function(index, item){
		ordstr.push(item.orditm);
		doctorID=item.doctorID;
    })
    $('#ordstr').html(ordstr.join(","));
    AddToAdviceList(ordstr.join(","),doctorID);
}

/// Ĭ����ʾ���������
function initScroll(){
	var opts=$('#medInfo').datagrid('options');    
	var text='{';    
	for(var i=0;i<opts.columns.length;i++)
	{    
		var inner_len=opts.columns[i].length;    
		for(var j=0;j<inner_len;j++)
		{    
			if((typeof opts.columns[i][j].field)=='undefined')break;    
			text+="'"+opts.columns[i][j].field+"':''";    
			if(j!=inner_len-1){    
				text+=",";    
			}    
		}    
	}    
	text+="}";    
	text=eval("("+text+")");    
	var data={"total":1,"rows":[text]};    
	$('#medInfo').datagrid('loadData',data);  
	$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
}

/// ��ȡ����
function getParam(paramName)
{
    paramValue = "";
    isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1)
    {
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        i = 0;
        while (i < arrSource.length && !isFound)
        {
            if (arrSource[i].indexOf("=") > 0)
            {
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase())
                 {
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        }   
    }
   return paramValue;
}

///������ҩ����
function AddToAdviceList(medAdvDrgItmList,doctorID)
{
	var AdvID="";  //$('#AdvID').html();     	/// ��ҩ����ID
	var UserID=LgUserID;                     	/// �û�ID
	var dataList=AdmDr+"^"+UserID+"^"+doctorID; /// ����Ϣ
	//var medAdvDetailList=$('#textarea').val();/// ��ҩ����
	//medAdvDetailList=UserID+"^"+medAdvDetailList.replace(/(^\s*)|(\s*$)/g,""); //ȥ����ʾ�ַ�

	//dataList=dataList+"!"+medAdvDrgItmList+"!"+medAdvDetailList;
	dataList=dataList+"!"+medAdvDrgItmList;
	
	var data=jQuery.param({"action":"SaveMedAdvMaster","AdvID":AdvID,"dataList":dataList});
	$.ajax({
        type:"POST",
        url:url,
        data:data,
        dataType:"json",
        error: function (XMLHttpRequest, textStatus, errorThrown){
    		
    	}, 
        success: function (val) {
	        var AdvID=val;
	        $('#AdvID').html(AdvID);
	    	LoadAdviceList(AdvID);  //������Ϣ
	    }
    });
}

function LoadAdviceList(AdvID)
{
	//��ȡ������Ϣ
 	 $.post(url,{action:"getPatMedAdvInfo",AdvID:AdvID},function(data,status){
	     var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
	     if(retVal!=""){
			InitAdivisesPanel(retVal,AdvID);
	     }
     });
}
function LoadAdviceLists(AdvID)
{
	//��ȡ������Ϣ
	$.ajax({
        type:"POST",
        url:url,
        async:false,
        data:{action:"getPatMedAdvInfo",AdvID:AdvID},
        dataType:"text",
        error: function (XMLHttpRequest, textStatus, errorThrown){
    		
    	}, 
        success: function (data) {
	         var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
	         if(retVal!=""){
			InitAdivisesPanel(retVal,AdvID);
	     }
	    }
    });
 	var advises='<a name='+'"'+AdvID+'"'+'></a>';
	$('#Adivises').append(advises);
}

///���ؽ�����Ϣ
function InitAdivisesPanel(retVal,AdvIDrtn)
{
	var htmlstr="";
	var medAdvDataArr=retVal.split("!");
	var AdvID=medAdvDataArr[0];             //RwoID
	var medAdvMasDateStr=medAdvDataArr[1];  //��ҩ��������Ϣ
	var medAdvDrgItmStr=medAdvDataArr[2];   //ҽ����Ϣ
	var medAdvContentStr=medAdvDataArr[3];  //������Ϣ
	
	//����Ϣ
	var medAdvMasArr=medAdvMasDateStr.split("^");
	if(AdvID==AdvIDrtn)
	htmlstr=htmlstr+"<div style='border-bottom: 2px solid #95B8E7;background: none repeat scroll 0% 0% #ADFAFC;padding: 10px 10px 15px 15px;position: relative;border-radius: 5px;box-shadow: 0px 3px 3px 0px #CCC inset;' name=list id="+AdvID+" >"
	else
	htmlstr=htmlstr+"<div style='border-bottom: 2px solid #95B8E7;background: none repeat scroll 0% 0% #FFFFFF;padding: 10px 10px 15px 15px;position: relative;border-radius: 5px;box-shadow: 0px 3px 3px 0px #CCC inset;' name=list id="+AdvID+" >"	
	htmlstr=htmlstr+"<span style='font-weight:bold;'>��Ч�ڣ�"+medAdvMasArr[0]+"</span><span style='font-weight:bold;'>��"+medAdvMasArr[1]+"</span><span style='font-weight:bold;margin-left:30px;color:red;'>"+medAdvMasArr[2]+"</span>"
	htmlstr=htmlstr+"<br>"
	//ҽ��
	htmlstr=htmlstr+"<span style='font-weight:bold;'>ԭҽ��:</span>";
	htmlstr=htmlstr+"<br>"
	var medAdvDrgItmArr=medAdvDrgItmStr.split("||");
	for(var k=0;k<medAdvDrgItmArr.length;k++)
	{
		htmlstr=htmlstr+"<span style='margin-left:30px;'>"+medAdvDrgItmArr[k]+"</span>"
		htmlstr=htmlstr+"<br>"
	}
	//����
	var medAdvContentArr=medAdvContentStr.split("||");
	htmlstr=htmlstr+"<span style='font-weight:bold;'>��ҩ����:</span>"
	htmlstr=htmlstr+"<br>"
	for(var k=0;k<medAdvContentArr.length;k++)
	{
		if(medAdvContentArr[k]!=""){
			htmlstr=htmlstr+"<span style='margin-left:30px;'>"+(k+1)+"��"+medAdvContentArr[k]+"</span>"
			htmlstr=htmlstr+"<br>";
		}
	}
	htmlstr=htmlstr+"<span style='margin-left:300px;font-weight:bold;'>ҩʦ��"+medAdvMasArr[3]+"</span><span style='margin-left:20px;font-weight:bold;'>"+medAdvMasArr[0]+"</span>"
	htmlstr=htmlstr+"</div>";
	
	$('#Adivises').append(htmlstr);
}

///������ҩ����
function sureAddMedAdvDetail()
{
	var medAdvDetailList=$('#textarea').val(); //��ҩ����
	if((medAdvDetailList=="�����뽨����Ϣ...")||(medAdvDetailList=="")){  //wangxuejian 2016-09-27
		$.messager.alert("��ʾ","�����������,�ٽ����ύ��");
		return;
	}

	var AdvID=$('#AdvID').html();  //��ȡ��ǰѡ����AdvID
        if (AdvID==""){
		$.messager.alert("��ʾ","��ѡ��ҩƷ��");  //����ǿ   2016-09-07
		return;
		}
	$('#'+AdvID).remove();
	var UserID=LgUserID; //session['LOGON.USERID']; //�û�ID

	var curStatus="10";  //����״̬   zhaowuqiang  2016/09/26 //cancel annotate by qnp
	//medAdvDetailList=UserID+"^"+medAdvDetailList.replace(/(^\s*)|(\s*$)/g,""); //ȥ����ʾ�ַ�
	medAdvDetailList=UserID+"^"+curStatus+"^"+medAdvDetailList.replace(/(^\s*)|(\s*$)/g,""); //ȥ����ʾ�ַ�
	var data=jQuery.param({"action":"SaveMedAdvDetail","AdvID":AdvID,"dataList":medAdvDetailList});
	$.ajax({
        type:"POST",
        url:url,
        data:data,
        dataType:"json",
        error: function (XMLHttpRequest, textStatus, errorThrown){
    		
    	}, 
        success: function (val) {
	        $('#AdvID').html(AdvID);
	    	LoadAdviceLists(AdvID);    //������Ϣ
	    	$('#textarea').val("");   //���textarea����
			location.hash=AdvID;
			$('#medAdvWin').css('display','none');	// �ύ����� ���ظ��˽���ģ���div����ʾ  �ֶ�����  qunianpeng 2018/3/21
	    }
    });
}

///���ز�����ҩ�����б�
function LoadPatAdviceList()
{
	if (AdmDr==""){return;}
	$.ajax({ 
        type: "POST", 
        url: "dhcpha.clinical.action.csp",
        async:false,
        //���������˿����ֶ�userLocCode 
        data:{action:"getPatAdviceList",AdmDr:AdmDr},
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
          var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		  if(retVal!=""){
			var medAdvPatAdvArr=retVal.split("#");
			for(var m=0;m<medAdvPatAdvArr.length;m++){
				InitAdivisesPanel(medAdvPatAdvArr[m]); //��������
			}
		  var advises='<a name='+'"goend"'+'></a>';
	      $('#Adivises').append(advises);
	      location.hash="goend";
	        }
        } 
    });
}

/// ɾ����ҩ����
function delMedAdvDetail()
{
	var AdvID=$('#AdvID').html();  //��ȡ��ǰѡ����AdvID
	if (AdvID==""){
		$.messager.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼��");
		return;
	}
	$.post("dhcpha.clinical.action.csp",{action:"delPatMedAdv",AdvID:AdvID},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$('#'+AdvID).remove();
			$.messager.alert("��ʾ","ɾ���ɹ���","info");
		}else if(retVal=="-1"){
			$.messager.alert("��ʾ","���鲻���ڣ�","error");
		}else if(retVal=="-2"){
			$.messager.alert("��ʾ","ҽ���ѻظ�,����ɾ����","error");
		}
	});
}

///��ʼ������ģ���б�
function InitMedAdvList()
{
	///����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Code',title:'����',width:100},
		{field:'Desc',title:'����',width:200},
	]];
	
	///����datagrid
	$('#medAdvdg').datagrid({
		//title:'',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){
			var tmpDesc=rowData.Desc;
			if($('#textarea').val()=="�����뽨����Ϣ..."){
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
function createSuggestWin()
{
	$('#medAdvWin').css('display','');  // ���ظ��˽���ģ���div��ʾ qunianpeng 2018/3/21
	$('#medAdvWin').window({
		title:'�����б�',    
		collapsible:true,
		border:true,
		closed:"true",
		width:800,
		height:400,
		minimizable:false						/// ������С����ť(qunianpeng 2018/3/15)
		//maximized:true						/// ���

	});

	$('#medAdvWin').window('open');
	
	///�Զ����ؽ����ֵ�
	$('#medAdvdg').datagrid({
		url:url+'?action=QueryMedAdvTemp',
		queryParams:{
			params:LgCtLocID+"^"+LgUserID
		}
	});
}

/// ��ҩ����ģ��ά��
function medAdvTemp()
{
	$('#medAdvTempWin').window({
		title:'��ҩ����ģ��ά��',    
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:400,
		minimizable:false						/// ������С����ť(qunianpeng 2018/3/15)
		//maximized:true						/// ���
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.medadvtemp.csp"></iframe>';
	$('#medAdvTempWin').html(iframe);
	$('#medAdvTempWin').window('open');
}

///���ز�����ҩ�б�
function LoadPatMedInfo(priCode,AppTypeCode)
{
	if(AppTypeCode!=""){AppTypeCode=AppType;}
	var allFlag = $("#chk-all").is(':checked');
	var priCode = $("input[type=radio]:checked").val();
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOrdItmInfoNew',	
		queryParams:{
			AdmDr:AdmDr,
			priCode:priCode,
			AppType:AppTypeCode,
			AllFlag: allFlag
		}
	});
initScroll("#medInfo");//��ʼ����ʾ���������
	$('#medInfo').datagrid('loadData', {total:0,rows:[]});  //�����ʼ��  nisijia 2016-09-07
}

