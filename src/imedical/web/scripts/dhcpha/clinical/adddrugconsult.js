/*
Creator:pengzhikun
CreatDate:2014-08-20
Description:��ҩ��ѯ->�����ѯ��¼����
*/
var url='dhcpha.clinical.action.csp' ;
var ageArray = [{ "val": "Y", "text": "��" }, { "val": "M", "text": "��" }];
var phrid="";
var choseFlag=0;  //ѡ����ѯ��ʽFlag  choseFlag=1 ҽ��/��ʿ   choseFlag=2 ����/����
function BodyLoadHandler()
{
	/*
	$('#tabPanel').tabs({
		border:false,
		fit:true
	});
	
	$('#doctorUl').click(function(){
			
			if($('#tabPanel').tabs('exists',"ҽ��/��ʿ��ѯ")){
				 $('#tabPanel').tabs('select',"ҽ��/��ʿ��ѯ");
			}else{
				$('#tabPanel').tabs('add',{
		 	   	  title:'ҽ��/��ʿ��ѯ',
		 	  	  closable:true,
		 	   	  href:'dhcpha.clinical.doctoraskpage.csp'
		    });
		  }
			
	});
	
	$('#patientUl').click(function(){
			if($('#tabPanel').tabs('exists',"����/������ѯ")){
				 $('#tabPanel').tabs('select',"����/������ѯ");
			}else{
				$('#tabPanel').tabs('add',{
		 	   	  title:'����/������ѯ',
		 	  	  closable:true
		 	   
		    });
		  }
	});
	*/

	
	
	
	//����columns
	var columns=[[
		{field:"rowid",title:'ID',width:60},
	    {field:'incidesc',title:'ҩƷ����',width:300,align:'left'},
	    {field:'genenic',title:'ͨ����',width:200,align:'left'},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',
		    width:30,
		    align:'center',
			formatter:SetCellUrl
		}
	]];
	
	//����datagrid
	$('#drugdg').datagrid({
		title:"",    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//�к� 
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            $("#drugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//����datagrid
	$('#patdrugdg').datagrid({
		title:"",    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//�к� 
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            $("#patdrugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	//InitdatagridRow();
	
}

/*
//��ʼ���б�ʹ��
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg").datagrid('insertRow',{
			index: 0, 
			row: {rowid:'',incidesc:'',genenic:''}
		});
	}
}
*/
/// ����
function SetCellUrl(value, rowData, rowIndex)
{	
	var dgID='"'+rowData.dgID+'"';
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

// ɾ����
function delRow(datagID,rowIndex)
{
	//�ж���
    var rowobj={
		rowid:'', incidesc:'', genenic:''
	};
	
	var selItem=$('#'+datagID).datagrid('getSelected');
	var rowIndex = $('#'+datagID).datagrid('getRowIndex',selItem);
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	
	$('#'+datagID).datagrid('deleteRow',rowIndex);
	
}


//ѡ��ҽ��/��ʿ��ѯ��ť
function doctorAskPage(){
	choseFlag=1;
	//���������ӽڵ�
	//$("#mainPanel").children().css("display","none");
	//��̬����һ��"���ҽ����ѯ��¼"��panel
	createDoctorPanel();
	//��������
	loadDoctorPageData();
	
}

//--ҽ��/��ʿ��ѯ����--//
function createDoctorPanel(){
	//����ʾҽ��/��ʿ��ѯ����
	//$("#docAskPanel").css("display","block");
	$('#docAskPanel').css("display","block");
	$('#docAskPanel').window({
		title:'ҽ��/��ʿ��ѯ����',
		width:1200,
		height:620,
		modal:true
	});
		
}

function loadDoctorPageData(){
	$('#drugdg').datagrid('loadData',{total:0,rows:[]});
	//��ѯ������
	$('#docName').combobox({
		url:url+'?actiontype=GetComboUser',
		//onShowPanel:function(){
			//$('#docName').combobox('reload',url+'?actiontype=GetComboUser')
		//},
		onLoadSuccess:function(){
		 	$('#docName').combobox('setValue',session['LOGON.USERID']);
		}
		//panelHeight:"auto",  //���������߶��Զ�����
		//url:url+'?actiontype=SelAllLoc' 
	});
	
	//$('#docName').combobox('setValue',session['LOGON.USERID']);
	
	//����
	$('#dept').combobox({
		url:url+'?actiontype=SelAllLoc&loctype=E',
		onLoadSuccess:function(){
		 	$('#dept').combobox('setValue',session['LOGON.CTLOCID']); //����comboboxĬ��ֵ
		}
		//onShowPanel:function(){
			//$('#dept').combobox('reload',url+'?actiontype=SelAllLoc&loctype=E')
		//}
		//panelHeight:"auto",  //���������߶��Զ�����
		//url:url+'?actiontype=SelAllLoc' 
	});
	
	
	//��ѯ���
	$("#docContype").combobox({
		onShowPanel:function(){
			$('#docContype').combobox('reload',url+'?actiontype=GetComboPhConType')
		}
	});
	
	//�������
	$("#docContQuetype").combobox({
		onShowPanel:function(){
			$('#docContQuetype').combobox('reload',url+'?actiontype=GetComboPhConQueType')
		}
	})
	
	//¼��ʱ��
	$("#docAskDate").datebox("setValue", formatDate(-1));
	
	
	//��ѯ���
	$("#drugdesc").combobox({
		
		onShowPanel:function(){
			alert($("#drugdesc").combobox('getText'));
			//$('#drugdesc').combobox('reload',url+'?actiontype=GetDrugByAlias')
		}
	});	
	
	//$('#drugNotice').bind('click',function(){
		//alert('hello');
	//})
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

//ѡ����/������ѯ��ť
function patientAskPage(){
	choseFlag=2;
	//���������������ӽڵ�
	//$("#mainPanel").children().css("display","none");
	//��̬����һ��"��ӻ���/������ѯ��¼"��panel
	createPatientPanel();
	//��������
	loadPatientPageData();	
}


//--����/������ѯ����--//
function createPatientPanel(){
	//����ʾ����/������ѯ����
	//$("#patAskPanel").css("display","block");
	$('#patAskPanel').css("display","block");
	$('#patAskPanel').window({
		title:'����/������ѯ����',
		width:1200,
		height:620,
		modal:true
	});
	
	
	//����ǼǺţ��س���ȡ���˻�����Ϣ	
	$('#patNo').bind('keypress',function(event){
		var keynum=event.keyCode||event.which;
		if(keynum==13){
			var input=$('#patNo').val();
			if(input.trim()==""||input.trim().length<8){
				alert('�������������˵ǼǺŽ��в�ѯ(8λ����)');
			}else{
				//$('#patNo').val("");
				getPatInfo(input);
			}
		}
	});	
		
}

//��ȡ���˻�����Ϣ
function getPatInfo(input){
	$.ajax({  
			type: 'POST',//�ύ��ʽ post ����get  
			url: url+'?actiontype=GetPatInf',//�ύ������ �����ķ���  
			data: "input="+input,//�ύ�Ĳ���  
			success:function(msg){            
				//alert("����ɹ�");//�������ڣ������msg ���� ���Ƿ���aaaa.action �� ��̨���Ĳ���
				//showSpeCrdList(msg);
				showPatInfo(msg)      
			},    
			error:function(){        
				alert("��ȡ����ʧ��!");
			}
		});
}

function showPatInfo(msg){
	/**
	* ���ҳ���ϵı���ļ�¼
	*/
	$('#patId').val("");
	$('#patName').val("");
	$('#patContact').val("");
	$('#sex input').each(function(){
		$(this).attr("checked",false);	
	});
	$('#age').val("")
	var obj = eval( "(" + msg + ")" ); //ת�����JSON����
	var arrayJson=obj.rows;
	if(obj.rows.length==0){
		alert("�ĵǼǺŲ�����,���߸ĵǼǺ��²�����ϢΪ��");
	}else{
		for(var i=0;i<arrayJson.length;i++){
			$('#patId').val(arrayJson[i].patId);
			$('#patName').val(arrayJson[i].patName);
			if(arrayJson[i].sex=="��"){
				$('#male').attr("checked",true);
			}else if(arrayJson[i].sex=="Ů"){
				$('#female').attr("checked",true);
			}else{
				$('#unknown').attr("checked",true);	
			}
			$('#patContact').val(arrayJson[i].tel);
			var ages=calAges(arrayJson[i].dob)
			if(ages!=""){
				var year=ages.split("-")[0];
				var month=ages.split("-")[1];
				if(year!=""){
					$('#age').val(year);
				}else{
					$('#ageUom').combobox('setValue',"M");
					if(month=0){
						//����һ���µİ�һ������ʾ
						$('#age').val(1);
					}else{
						$('#age').val(month);
					}
				}
			}
		}
	}
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

//��ȡ������Ⱥ�б�,����̬��ʾ
function GetSpCrdList(){
	$.ajax({  
			type: 'POST',//�ύ��ʽ post ����get  
			url: url+'?actiontype=GetSpCrdList',//�ύ������ �����ķ���  
			//data: "input="+input,//�ύ�Ĳ���  
			success:function(msg){            
				//alert("����ɹ�");//�������ڣ������msg ���� ���Ƿ���aaaa.action �� ��̨���Ĳ���
				showSpeCrdList(msg);       
			},    
			error:function(){        
				alert("��ȡ����ʧ��!");
			}
		}); 
}


function loadPatientPageData(){
	$('#patdrugdg').datagrid('loadData',{total:0,rows:[]});
	//����������Ⱥ�б�
	GetSpCrdList();
	//���䵥λ
	$('#ageUom').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:ageArray 
	});
	$('#ageUom').combobox('setValue',"Y"); //����comboboxĬ��ֵ
	
	//��ѯ���
	$("#patContype").combobox({
		onShowPanel:function(){
			$('#patContype').combobox('reload',url+'?actiontype=GetComboPhConType')
		}
	})
	//�������
	$("#patConQuetype").combobox({
		onShowPanel:function(){
			$('#patConQuetype').combobox('reload',url+'?actiontype=GetComboPhConQueType')
		}
	})
	//¼��ʱ��
	$("#patAskDate").datebox("setValue", formatDate(-1));
}

function showSpeCrdList(msg){
	var id=$('#speCrowd');
	removeAllAnswer(id);
	var obj = eval( "(" + msg + ")" ); //ת�����JSON����
	var arrayJson=obj.rows;
	for(var i=0;i<arrayJson.length;i++){
		$('<input />',{
			type:"checkbox",
			value:arrayJson[i].rowid
		}).insertBefore($('<label />',{text:arrayJson[i].desc}).appendTo('#speCrowd'));
	}

}

function removeAllAnswer(id){
	id.children().remove();
}


//�ύ���� --ҽ��/��ʿ��ѯ����
function saveDocQuetion(){
	var docNameDr=$('#docName').combobox('getValue');
	var deptDr=$('#dept').combobox('getValue');
	var docContypeDr=$('#docContype').combobox('getValue');
	var askDate=$('#docAskDate').datebox('getValue');
	var docContQuetypeDr=$('#docContQuetype').combobox('getValue');
	var questionDesp=$('#DocquestionDesp').val();
	var userType="1" //--ҽ��/��ʿ
	
	var stuData=$('#drugdg').datagrid("getData"); 
	var length=stuData.rows.length;
	var drugIds="";
	for(var i=0;i<length;i++){
		drugIds=drugIds+stuData.rows[i].rowid+"^"
		
	}
	//var drugs=$('#drugs').val().split("^");
	//var drugIds="";
	//if(drugs.length>0){
		//for(var i=1;i<drugs.length;i++){
		
			//drugIds=drugIds+drugs[i].split("-")[0]+"^"
		//}
	//}
	
	//ҽ��/��ʿ��ѯʱ,"������Ⱥ�����Բ�����ע"�����ڲ��˵ľ������
	var input=docNameDr+"^"+deptDr+"^"+docContypeDr+"^"+docContQuetypeDr+"^"+askDate+"^"+questionDesp+"^"+userType+"^"+""+"^"+""+"^"+""+"||"+drugIds
	//alert(input);
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?actiontype=SaveQuestion',//�ύ������ �����ķ���  
		data: "input="+input,//�ύ�Ĳ���  
		success:function(){            
			alert("����ɹ�");//�������ڣ������msg ���� ���Ƿ���aaaa.action �� ��̨���Ĳ���         
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	});
	       
	
}


//�ύ���� --����/������ѯ����
function savePatQuetion(){
	//����id
	var patId=$('#patId').val();
	//��������
	var inputs=$("#speCrowd input");
	var ckValueList="";
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].checked==true){
			//alert(inputs[i].value)
			ckValueList+=inputs[i].value+"||"
		}		
	}
	
	//ckValueList="1||2||",�����Ϊ�գ�����ת��Ϊ"1,2"
	if(ckValueList!=""){
		var length=ckValueList.split("||").length;
		ckValueList=ckValueList.split("||",length-1);
	}
	
	var chrDis=$('#ChrDise').val();   //���Բ�
	var remarks=$('#remark').val();   //��ע
	var patContypeDr=$('#patContype').combobox('getValue');
	var askDate=$('#patAskDate').datebox('getValue');
	var patContQuetypeDr=$('#patConQuetype').combobox('getValue');
	var questionDesp=$('#questionDespPat').val();
	var userType="2" //--����/����
	
	var stuData=$('#patdrugdg').datagrid("getData"); 
	var length=stuData.rows.length;
	var drugIds="";
	for(var i=0;i<length;i++){
		drugIds=drugIds+stuData.rows[i].rowid+"^"
		
	}
	/*
	var drugs=$('#patientDrugs').val().split("^");
	var drugIds="";
	if(drugs.length>0){
		for(var i=1;i<drugs.length;i++){
		
			drugIds=drugIds+drugs[i].split("-")[0]+"^"
		}
	}*/
	
	var input=patId+"^"+""+"^"+patContypeDr+"^"+patContQuetypeDr+"^"+askDate+"^"+questionDesp+"^"+userType+"^"+ckValueList+"^"+chrDis+"^"+remarks+"||"+drugIds;
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?actiontype=SaveQuestion',//�ύ������ �����ķ���  
		data: "input="+input,//�ύ�Ĳ���  
		success:function(){            
			alert("����ɹ�");//�������ڣ������msg ���� ���Ƿ���aaaa.action �� ��̨���Ĳ���         
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	}); 
	  
	
}

//������ѯҩƷ��
function popDrugInfoWin(){
	$('#popDrugWindow').css("display","block");
	$('#popDrugWindow').window({
		width:600,
		height:500,
		modal:true
	});
	$('#drugalias').bind('keypress',function(event){
			var keynum=event.keyCode||event.which;
			if(keynum==13){
				var input=$('#drugalias').val();
				if(input.trim()==""||input.trim().length<3){
					alert('����������в�ѯ(�����볬��3���ַ�)');
				}else{
					$('#drugalias').val("");
					showDrug(input);
				}
			}
	})
	
}


//�����ѯҩƷ��ť
function searchDrugByAlias(){
	var input=$('#drugalias').val();
	if(input.trim()==""||input.trim().length<3){
		alert('����������в�ѯ(�����볬��3���ַ�)');
	}else{
		showDrug(input);
		//$('#drugalias').val()="";
	}
	
}

//��ʾҩƷ�б�
function showDrug(input){
	$('#druggrid').datagrid({  
		border:false,
		url:url+'?actiontype=FindDrugs&input='+input,
		rownumbers:true,
		striped: true,
		//pageList : [10, 20, 30],   // ��������ÿҳ��¼�������б�
		//pageSize : 10 ,  // ÿҳ��ʾ�ļ�¼����
		fitColumns:true,
		//sortName: "rowid", //��ʼ�����ʱ���ݵ����� �ֶ� ��������ݿ��е��ֶ�������ͬ
		//sortOrder: "asc",
		fit: true,
		loadMsg: '���ڼ�����Ϣ...',
		singleSelect:true,
		columns:[[     			  
			{field:'incirowid',title:'Rowid',width:50},
			{field:'incidesc',title:'ҩƷ����',width:160},
			{field:'genericdesc',title:'ҩƷͨ����',width:120}
	
		]],
		onDblClickRow:function() { 
    		var selected = $('#druggrid').datagrid('getSelected'); 
    		if (selected){ 
      			//alert(selected.incirowid); 
      			$('#popDrugWindow').window('close');
      			
      			if(choseFlag==1){
      				//$('#drugs').val($('#drugs').val()+"^"+selected.incirowid+"-"+selected.incidesc)
      				var rowobj={
						rowid:selected.incirowid, incidesc:selected.incidesc, genenic:selected.genericdesc, 
		    			dgID:'drugdg'
					}
					$("#drugdg").datagrid('appendRow',rowobj);
					
      			}else if(choseFlag==2){
	      			var rowobj={
						rowid:selected.incirowid, incidesc:selected.incidesc, genenic:selected.genericdesc, 
		    			dgID:'patdrugdg'
					}
					$("#patdrugdg").datagrid('appendRow',rowobj);
	      			//$('#patientDrugs').val($('#patientDrugs').val()+"^"+selected.incirowid+"-"+selected.incidesc)
	      		}
			} 
		} 
		//pagination: true
		
		//queryParams: {
			//action:'FindResults'
			//input:""
		//}

	});
	
	//���÷�ҳ�ؼ�   
	//$('#druggrid').datagrid('getPager').pagination({
		//showPageList:false,
		//beforePageText: '��',//ҳ���ı���ǰ��ʾ�ĺ��� 
		//afterPageText: 'ҳ    �� {pages} ҳ',   
		//displayMsg: '��ǰ��ʾ {from} - {to} ����¼   �� {total} ����¼'
	//});
}

//���˵������ı���Ϣ�пո�
String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
}
