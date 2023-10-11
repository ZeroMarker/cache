/// Creator: zhaowuqiang
/// CreateDate: 2016-12-14
//  Descript:��λ���ά��ά��

var editRow="",editparamRow="",clicknum="";  //��ǰ�༭�к�
var dataArray=[{"value":"Y","text":"��"},{"value":"N","text":"��"}]; //hxy 2018-10-12
$(function(){	
	hospComp = GenHospComp("DHC_EmPatSeatCat");  //hxy 2020-05-22 st
	hospComp.options().onSelect = function(){///ѡ���¼�
		findSeatStatus();
	}
    var HospDr=hospComp.getValue();//ed
    
	var Flageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			editable:false, //huaxiaoying 2017-01-06
			onSelect:function(option){
				///��������ֵ
				var ed=$("#seatcatlist").datagrid('getEditor',{index:editRow,field:'enabled'});
				
				//$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
			} 
		}

	}
	
	var Hospitaleditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			//url:LINK_CSP+"?ClassName=web.DHCEMPatSeatCat&MethodName=SelHosDesc",
			url:LINK_CSP+"?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs", //huaxiaoying 2016-01-06
			required:false, //hxy 2019-09-18 true
			editable:false, //huaxiaoying 2017-01-06
			panelHeight:"200",  //���������߶��Զ�����
			onSelect:function(option){
				var ed1=$("#seatcatlist").datagrid('getEditor',{index:editRow,field:'hospId'});  
				$(ed1.target).val(option.value);    //	QQA 2017-1-12  ���ü���
			} 
		}
	}
	
	// ����columns
	var columns=[[
		{field:"seatcode",title:'����',width:100,align:'center',editor:{type:'validatebox',options:{required:true}}}, 
		{field:"seatdesc",title:'����',width:130,align:'center',editor:{type:'validatebox',options:{required:true}}},
		{field:"seatcolor",title:'��ɫ',width:130,align:'center',editor:{type:'colorpicker'},formatter:formatterSeatColor,styler:stylerSeatColor},
		{field:"seatcolorvalue",title:'��ɫ2',width:130,align:'center',editor:{type:'validatebox',options:{}},hidden:true},
		{field:"hosdesc",title:'ҽԺ',width:220,align:'center',editor:Hospitaleditor,hidden:true}, //hxy 2019-09-18
		{field:'enabled',title:'�Ƿ����',width:130,align:'center',editor:Flageditor,
				formatter:function(value,row,index){
					if (value=='Y'){return '��';} 
					else {return '��';}
				}}, 
		{field:'hospId',title:'ҽԺID',width:130,align:'center',hidden:true,editor:{type:'validatebox',options:{required:false}}},   //QQA �����ֶλ�ȡҽԺID //hxy 2019-09-19 ȥ������
		{field:"seatid",title:'ID',width:70,align:'center',editor:{type:'validatebox'},hidden:true}
	]];
	// ����datagrid
	$('#seatcatlist').datagrid({
		title:'',
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatSeatCat&MethodName=QuerySeatCat&HospDr='+HospDr, //huaxiaoying 2017-1-4 �淶���� //hxy 2020-05-22 &HospDr='+HospDr
		fit:true,
		border:false,//hxy 2018-10-12
		rownumbers:false,
		columns:columns,
		pageSize:30,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,60],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    	clicknum=rowIndex;
            if(editRow>="0"){
				$("#seatcatlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
			}
            $("#seatcatlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrStatus(this.id+"^"+$('#'+this.id).val()); //���ò�ѯ
            findSeatStatus(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
   /* $('#find').bind('click',function(event){
         findSeatStatus(); //���ò�ѯ
    });
 */
})

// ������
function insertRow()
{
	clicknum="";
	var HospDr=hospComp.getValue(); //hxy 2020-05-22
	if(editRow>="0"){
		$("#seatcatlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#seatcatlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {seatid: '',seatcode:'',seatdesc: '',rowsData:'',hosdesc:HospDr,enabled:'Y',hospId:HospDr} //huaxiaoying 2017-01-06 //2019-07-26 LgHospID //hxy 2020-05-22 LgHospID->HospDr
		//row: {seatid: '',seatcode:'',seatdesc: '',rowsData:'',hosdesc:LgHospID,enabled:'Y',hospId:LgHospID} //huaxiaoying 2017-01-06 //2019-07-26 LgHospID

	});
            
	$("#seatcatlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rowsData = $("#seatcatlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMPatSeatCat","DelSeatCat",{"params":rowsData.seatid},function(ret){
					if(ret==-1024){
						$.messager.alert("��ʾ","����ɾ���Ѿ�ʹ�ô�������Һ����λ��")
					}else{
						$('#seatcatlist').datagrid('reload'); //���¼���
					}
				},"text")
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function saveRow()
{
	if(editRow>="0"){
		$("#seatcatlist").datagrid('endEdit',editRow);
	}
	
	var rowsData = $("#seatcatlist").datagrid('getChanges');

	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].seatcode=="")||(rowsData[i].seatdesc=="")){ //hxy 2019-09-18
		//if((rowsData[i].seatcode=="")||(rowsData[i].seatdesc=="")||(rowsData[i].hosdesc=="")){ //huaxiaoying 2017-01-06
			$.messager.alert("��ʾ","��༭��������!"); 
			return false;
		}
		var tmp=rowsData[i].seatid +"^"+ rowsData[i].seatcode +"^"+ rowsData[i].seatdesc +"^"+ rowsData[i].enabled +"^"+ rowsData[i].hospId+"^"+rowsData[i].seatcolorvalue;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCEMPatSeatCat","SaveSeatCat",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ","����ɹ�!"); 
			$('#seatcatlist').datagrid('reload'); //���¼���
		}else if(jsonString==-96){
			$.messager.alert("��ʾ","�����ظ�!"); 
			$('#seatcatlist').datagrid('reload'); //���¼���
		}else if(jsonString==-95){
			$.messager.alert("��ʾ","����¼���ظ�!"); 
			$('#seatcatlist').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ","����ʧ��!"); 
			$('#seatcatlist').datagrid('reload'); //���¼���
		}
	});
}

function formatterSeatColor(value,row,index){
	if((value=="")||(value==undefined)){
		value=row.seatcolorvalue;
	}
	return value;
}

function stylerSeatColor(value,row,index){
	var ret="";
	if((value=="")||(value==undefined)){
		value=row.seatcolorvalue;
	}
	if(value!=""){
		ret = "background-color:"+value;
	}
	return ret
}
// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

// ��ѯ
function findSeatStatus()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	var HospDr=hospComp.getValue();
	$('#seatcatlist').datagrid('load',{params:params,HospDr:HospDr}); 
}


//���ӱ༭��
$.extend($.fn.datagrid.defaults.editors, {
	colorpicker: {
		init: function(container, options){
			var input = $('<input type="text" style="height:22px"/>').appendTo(container);
			return input.ColorPicker({
				onSubmit: function(hsb, hex, rgb, el) {
					$(el).val(hex);
					$(el).ColorPickerHide();
					var ed=$("#seatcatlist").datagrid('getEditor',{index:editRow,field:'seatcolorvalue'});
					$(ed.target).val("#"+hex);
				},
				onBeforeShow: function () {
					$(this).ColorPickerSetColor(this.value);
				}
			}).bind('keyup', function(){
				$(this).ColorPickerSetColor(this.value);
				var ed=$("#seatcatlist").datagrid('getEditor',{index:editRow,field:'seatcolorvalue'});
				$(ed.target).val("#"+this.value);
			});
		},
		destroy: function(target){
			
		},
		getValue: function(target){
			
		},
		setValue: function(target, value){	
			if((value=="")||(value==undefined)){
				if(clicknum>="0"){
					var tbed=$('#seatcatlist').datagrid('getRows')[clicknum];
					value=tbed.seatcolorvalue;
				}
			}
			if(value!=""&&value!=undefined) $(target).val(value.split("#")[1]);
		},
		resize: function(target, width){
			
		}
	}
});
