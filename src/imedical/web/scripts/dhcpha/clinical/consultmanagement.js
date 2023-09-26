/*
Creator:pengzhikun
CreatDate:2014-08-20
Description:��ҩ��ѯ-->��ѯ��¼����
*/
var url='dhcpha.clinical.action.csp' ;
var ageArray = [{ "val": "Y", "text": "��" }, { "val": "M", "text": "��" }, { "val": "D", "text": "��" }];
var roleArray=[{ "val": "D", "text": "ҽ��/��ʿ" }, { "val": "P", "text": "����/����" }];
var phrid="";
var phdelrid="";
function BodyLoadHandler()
{
	initData();
	loadData();
		
}



function initData(){
	//�������
	$("#MPQuestion").combobox({
		onShowPanel:function(){
			$('#MPQuestion').combobox('reload',url+'?actiontype=GetComboPhConQueType')
		}
	})
	
	//��ɫ
	$('#MPRoles').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:roleArray 
	});
	//$('#MPRoles').combobox('setValue',"D"); //����comboboxĬ��ֵ
	
	//��ѯ������
	$('#MPAsker').combobox({
		onShowPanel:function(){
			$('#MPAsker').combobox('reload',url+'?actiontype=GetComboUser')
		}
		//panelHeight:"auto",  //���������߶��Զ�����
		//url:url+'?actiontype=SelAllLoc' 
	});
	
	$('#ctloc').combobox({
		onShowPanel:function(){
			$('#ctloc').combobox('reload',url+'?actiontype=SelAllLoc&loctype=E')
		}
		//panelHeight:"auto",  //���������߶��Զ�����
		//url:url+'?actiontype=SelAllLoc' 
	});
	//��ֹʱ��
	$("#startdate").datebox("setValue", formatDate(-1));
	$("#enddate").datebox("setValue", formatDate(-1));
}

function Query(){
	loadData();
}

function loadData(){
	
	var question=$('#MPQuestion').combobox('getValue');
	if(question==undefined){
		question="";	
	}
	var asker=$('#MPAsker').combobox('getValue');
	var ctloc=$('#ctloc').combobox('getValue');
	if(ctloc==undefined){
		ctloc="";	
	}
	var stDate=$('#startdate').datebox('getValue');
	var endDate=$('#enddate').datebox('getValue');
	//var questionDesp=$('#DocquestionDesp').val();
	//var drugs=$('#drugs').val().split("^");
	//var drugIds="";
	//if(drugs.length>0){
		//for(var i=1;i<drugs.length;i++){
		
			//drugIds=drugIds+drugs[i].split("-")[0]+"^"
		//}
	//}
	var input=question+"^"+asker+"^"+ctloc+"^"+stDate+"^"+endDate
	
	$('#questiongrid').datagrid({  
		border:false,
		title:'��ѯ��¼�б�',
		url:url+'?actiontype=FindResults&input='+input,
		rownumbers:true,
		striped: true,
		pageList : [10, 20, 30],   // ��������ÿҳ��¼�������б�
		pageSize : 10 ,  // ÿҳ��ʾ�ļ�¼����
		fitColumns:true,
		//sortName: "rowid", //��ʼ�����ʱ���ݵ����� �ֶ� ��������ݿ��е��ֶ�������ͬ
		//sortOrder: "asc",
		fit: true,
		loadMsg: '���ڼ�����Ϣ...',
		singleSelect:true,
		columns:[[     
			{field:'askdate',title:'��ѯ����',width:40},   
			{field:'questionkinds',title:'��������',width:60},
			{field:'drugs',title:'ҩƷ���',width:100,formatter:function(value,data,index){
					//'showWin("+rowData.detailinfo+")'
					return format(value);
				}
			},
			{field:'role',title:'��ѯ�����',width:40},
			{field:'personname',title:'��ѯ������',width:40},  
			{field:'question',title:'��ѯ����',width:80},
			{field:'hasAnswer',title:'�ظ�',width:40,formatter:function(value,data,index){
					//'showWin("+rowData.detailinfo+")'
					var str="";
					if(value=="��"){
						str="<span style='color:#66CCCC; font-weight:bold'>"+value+"</span>"
					}else{
						str="<span style='color:#CCFF66; font-weight:bold'>"+value+"</span>"
					}
					return str;
				}
			},
			{field:'hasStdAnswer',title:'��׼�ظ�',width:40,formatter:function(value,data,index){
					//'showWin("+rowData.detailinfo+")'
					var str="";
					if(value=="��"){
						str="<span style='color:Blue; font-weight:bold'>"+value+"</span>"
					}else{
						str="<span style='color:Red; font-weight:bold'>"+value+"</span>"
					}
					return str;
				}
			},
			{field:'detailinfo',title:'����',width:40,formatter:function(value,data,index){
				     //'showWin("+rowData.detailinfo+")'
					return "<a href='#' style='text-decoration:none' onclick='showWin("+index+")'>"+value+"</a>";
				}
			} 
		]],
		 pagination: true
		
		//queryParams: {
			//action:'FindResults'
			//input:""
		//}

	});
	
	//���÷�ҳ�ؼ�   
	$('#questiongrid').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '��',//ҳ���ı���ǰ��ʾ�ĺ��� 
		afterPageText: 'ҳ    �� {pages} ҳ',   
		displayMsg: '��ǰ��ʾ {from} - {to} ����¼   �� {total} ����¼'
	});
	
	
		
}

function format(value){
	var valueArr=value.split(",");
	var str="<div style='padding:5px'>";
	for(var i=0;i<valueArr.length-1;i++){
		str=str+"<span style='font-size:12px'>"+value.split(",")[i]+"</span>"+"<br\>"
	}
	str=str+"<span style='font-size:12px'>"+value.split(",")[valueArr.length-1]+"</span>"+"</div>";
	return str;
	
	
}

/// ��ʽ������
function formatDate(t)
{
	var curr_time = new Date();  
	var Year = curr_time.getFullYear();
	var Month = curr_time.getMonth()+1;
	var Day = curr_time.getDate()+parseInt(t);
	return Month+"/"+Day+"/"+Year;
}

///��ϸ��Ϣ
///��ʾ���� formatter="SetCellUrl"
function showWin(index)
{	
	//alert(index);
	var id=$('#allAnswer1');
	removeAllAnswer(id);
	//��ȡdatagrid���ص�json����
	var d = $('#questiongrid').datagrid("getData");
	var detail=d.rows;
	phrid=detail[index].rowid;
	if(detail[index].role=="ҽ��/��ʿ"){
		$('#patname').html("");
		$('#patphoneNumber').html("");
		$('#gender').html("");	
		$('#patage').html("");	
		$('#specicalPop').html("");
		$('#chronicDiseases').html("");
		$('#patremarks').html("");
		
		$('#DetailWinDocName').html(detail[index].personname);
		$('#DetailWinCtlocName').html(detail[index].ctloc);
	}else if(detail[index].role=="����/����"){
		$('#DetailWinDocName').html("");
		$('#DetailWinCtlocName').html("");
		
		$('#patname').html(detail[index].personname);
		$('#patphoneNumber').html(detail[index].patTel);
		$('#gender').html(detail[index].patSex);
		var ages=calAges(detail[index].patDob);
		if(ages!=""){
				var year=ages.split("-")[0];
				var month=ages.split("-")[1];
				if(year!=""){
					$('#patage').html(year+"��");
				}else{
					if(month=0){
						//����һ���µİ�һ������ʾ
						$('#patage').html(1+"��");
					}else{
						$('#patage').html(month+"��");
					}
				}
			}
		$('#specicalPop').html(detail[index].speCrowd);
		$('#chronicDiseases').html(detail[index].chrDisease);
		$('#patremarks').html(detail[index].remark);
		
	}
	$('#DetailWinQuestion').html(detail[index].questionkinds);
	$('#DetailWinRelativeDrugs').html(detail[index].drugs);
	$('#DetailWinQuestionDesc').html(detail[index].question+"?")
	getAnswer(phrid);
	//createPopInfoWin();
}

//ͨ���������ڼ������� str="1989-08-08"
function calAges(str)   
  {   
        var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);     
        if(r==null)return   false;     
        var d = new Date(r[1],r[3]-1,r[4]);     
        if(d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4])   
        {   
             var Y =new Date().getFullYear();
	      	 var M =new Date().getMonth();  
	      	 //(Y-r[1])��   (M-r[3]+1)��
             return((Y-r[1])+"-"+(M-r[3]+1));   
        }   
        return "";   
  }


function getAnswer(phrid){
	$.ajax({  
			type: 'POST',//�ύ��ʽ post ����get  
			url: url+'?actiontype=getAllAnswer',//�ύ������ �����ķ���  
			data: "input="+phrid,//�ύ�Ĳ���  
			success:function(msg){            
				//alert("����ɹ�");//�������ڣ������msg ���� ���Ƿ���aaaa.action �� ��̨���Ĳ���
				//$('#ResWinAnswer').val("");
				//$('#popResWindow').window('close');
				//alert(msg)
				createPopInfoWin(msg);       
			},    
			error:function(){        
				alert("��ȡ����ʧ��!");
			}
		}); 
}

//var jsonstr="{rows:1,name:'penzi',address:'wuhan',results:[{id:1,desc:'001'},{id:2,desc:'002'}]}";
//var obj = eval( "(" + jsonstr + ")" );//ת�����JSON����
//var arrayJson=obj.results;
function createPopInfoWin(msg){
	var obj = eval( "(" + msg + ")" ); //ת�����JSON����
	var arrayJson=obj.rows;
	for(var i=0;i<arrayJson.length;i++){	
		//
		var mydivWrap=$('<div></div>')
		mydivWrap.attr('id','wraper'+i);
		mydivWrap.css('border-style','solid solid none');
		mydivWrap.css('border-color','#CCC #CCC');
		
		//header
		var mydivHeader=$('<div></div>');
		mydivHeader.css('background-color','#EFEFEF');
		mydivHeader.css('line-height','25px');
		mydivHeader.attr('id','answer'+i);
		$('<span />',{
			text:i+1+"¥",
			"class":"header"
		}).appendTo(mydivHeader);
		
		$('<span />',{
			text:'�ظ���:',
			"class":"answerer"
		}).appendTo(mydivHeader);
		
		$('<span />',{
			text:arrayJson[i].username,
			"class":"name"
		}).appendTo(mydivHeader);
		
		if(arrayJson[i].ansUsername !=""){
			$('<span />',{
				text:'���ظ���:',
				"class":"answerer1"
			}).appendTo(mydivHeader);
		
			$('<span />',{
				text:arrayJson[i].ansUsername,
				"class":"name1"
			}).appendTo(mydivHeader);
		}
		
		$('<span />',{
			text:'�ظ���:',
			"class":"answered"
		}).appendTo(mydivHeader);
		
		$('<span />',{
			text:arrayJson[i].answerDate,
			"class":"date"
		}).appendTo(mydivHeader);
		
		$('<span />',{
			text:arrayJson[i].answerTime,
			"class":"time"
		}).appendTo(mydivHeader);
		
		
		
		//content
		var mydivContent=$('<div></div>');
		mydivContent.css('background-color','#F4F4F4');
		mydivContent.css('height','20px');
		
			
		$('<span />',{
                        text:arrayJson[i].answer,
			//text:""+arrayJson[i].answer,
			"class":"content"
		}).appendTo(mydivContent);
		
		
		if(arrayJson[i].basList!=""){
			$('<span />',{
				text:"["+"�ο���"+arrayJson[i].basList+"]",
				style:'color:#CCCCCC'
			}).appendTo(mydivContent);
		}
		
		if(arrayJson[i].okFlag=="Y"){
			$('<span />',{
                        	text:"�����",
				style:'color:#0099cc'
			}).appendTo(mydivContent);
		}
		
		//footer
		var mydivFooter=$('<div></div>');
		mydivFooter.css('background-color','#F4F4F4');
		//mydivFooter.css('height','20px');
		mydivFooter.attr('id','foot');
		
		$('<a />',{
			text:arrayJson[i].detailRid,
			href:'#',
			"class":"rowid",
			click:function(){
				//alert(arrayJson[i].detailRid);
			}
			
		}).appendTo(mydivFooter);
		
		$('<a />',{
			text:'���',
			href:'#',
			"class":"ah",
			click:function(){
				//alert(arrayJson[i].detailRid);
				var DetailRowid=$(this).parent().children(".rowid").text();
				//���
				setOkFlag(DetailRowid);
			}
			
		}).appendTo(mydivFooter);
		
		$('<span />',{
			text:'|'
		}).appendTo(mydivFooter);
		
		
		$('<a />',{
			text:'�ظ�....',
			"class":"ah",
			href:'#',
			click:function(){
				$('#ResWinAnswer').focus();
				phdelrid=$(this).parent().children(".rowid").text();
			}
			
		}).appendTo(mydivFooter);
		
		
		$(mydivHeader).appendTo(mydivWrap);
		$(mydivContent).appendTo(mydivWrap);
		$(mydivFooter).appendTo(mydivWrap);
		
		$(mydivWrap).appendTo('#allAnswer1');
		
	}
	
		
	//��ȡ�ظ������б�,����̬��ʾ��ʾ
	getConBas();
	
	$('#popwindow').css("display","block");
	$('#popwindow').window({
		width:900,
		height:600,
		modal:true
	})
	//��̬����
	//appendTo('#allAnswer')
}

function setOkFlag(DetailRowid){
	$.ajax({  
			type: 'POST',//�ύ��ʽ post ����get  
			url: url+'?actiontype=SetOkFlag',//�ύ������ �����ķ���  
			data: "input="+DetailRowid,//�ύ�Ĳ���  
			success:function(msg){            
				//alert("����ɹ�");//�������ڣ������msg ���� ���Ƿ���aaaa.action �� ��̨���Ĳ���
				//showConBasList(msg);
				if(msg==-1){
					alert("�Ѿ��б�׼�𰸣���");
				}else if(msg==0){
					alert("���ɱ�׼�𰸣���");
				}else{
					alert("���ɱ�׼��ʧ�ܣ���");
				}      
			},    
			error:function(){        
				alert("��ȡ����ʧ��!");
			}
	}); 		
}

//��ȡ�ظ������б�,����̬��ʾ��ʾ
function getConBas(){
	$.ajax({  
			type: 'POST',//�ύ��ʽ post ����get  
			url: url+'?actiontype=GetConBas',//�ύ������ �����ķ���  
			//data: "input="+input,//�ύ�Ĳ���  
			success:function(msg){            
				//alert("����ɹ�");//�������ڣ������msg ���� ���Ƿ���aaaa.action �� ��̨���Ĳ���
				showConBasList(msg);       
			},    
			error:function(){        
				alert("��ȡ����ʧ��!");
			}
		}); 
}

function showConBasList(msg){
	var id=$('#footdiv');
	removeAllAnswer(id);
	var obj = eval( "(" + msg + ")" ); //ת�����JSON����
	var arrayJson=obj.rows;
	$('<label />',{
		text:'�ظ����ݣ�',
		style:"background-color:#CCCCFF"
	}).appendTo('#footdiv');
	
	for(var i=0;i<arrayJson.length;i++){
		$('<input />',{
			type:"checkbox",
			value:arrayJson[i].rowid
		}).insertBefore($('<label />',{text:arrayJson[i].PhContBDesc}).appendTo('#footdiv'));
	}
}


function removeAllAnswer(id){
	id.children().remove();
}


///�ύ�ظ�
function submitAnswer(){
	var userId=session['LOGON.USERID'];
	var questionDesp=$('#ResWinAnswer').val().trim();
	var inputs=$("#footdiv input");
	var ckValueList="";
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].checked==true){
			//alert(inputs[i].value)
			ckValueList+=inputs[i].value+"^"
		}		
	}
	//ckValueList="1||2||",�����Ϊ�գ�����ת��Ϊ"1,2"
	if(ckValueList!=""){
		var length=ckValueList.split("||").length;
		ckValueList=ckValueList.split("||",length-1);
	}

	if(questionDesp==""){
		alert("������ظ�")
	}else{
		var input=phrid+"^"+userId+"^"+questionDesp+"^"+phdelrid+"^"+ckValueList;
		$.ajax({  
			type: 'POST',//�ύ��ʽ post ����get  
			url: url+'?actiontype=submitAnswer',//�ύ������ �����ķ���  
			data: "input="+input,//�ύ�Ĳ���  
			success:function(){            
				alert("����ɹ�");//�������ڣ������msg ���� ���Ƿ���aaaa.action �� ��̨���Ĳ���
				$('#ResWinAnswer').val("");
				$('#popResWindow').window('close');         
			},    
			error:function(){        
				alert("����ʧ��");
			}
		}); 
	}
}

//���˵������ı���Ϣ�пո�
String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
}
					  
