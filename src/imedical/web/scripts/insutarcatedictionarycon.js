/**
 * �������Ͷ���JS
 * FileName:insutarcatedictionarycon.js
 * xubaobao 2019-04-04
 * �汾��V1.0
 * hisui�汾:0.1.0
 */

//===========�޸Ĳ���=================��ʼ
//��ҽ���ֵ���еĻ�������(������ҽ�����ͱ���,ҽ�����ͱ����ɳ�����ƥ�䡣�������ݿ���ʵ�����õ���DosageZZA)
var DicCode="med_chrgitm_type";             //�������� 
// ��ȡ�ֵ����ݵ���������������(His�е��ֵ��б�)
// ����ķ������Լ���д����ֵ �̶���ʽ(List)
var HisDicClass="web.INSUDictionaryContrast";         //����
var HisDicMethod="GetHisTarCateList";                            //������
//===========�޸Ĳ���=================����
$(function(){
	setPageLayout() ;
	setElementEvent();
});

function setElementEvent()
{
	//gridview �������Ӧ
	/*
	$(window).resize(function(){
		DataGVWidthResize('HISInfoArea');    //�������Ӧ
		DataGVWidthResize('MedicalArea');    //�������Ӧ
	});*/
	//$('#TitleName').html(PageName);
	
	//his�ֵ估���չ�ϵ����
	/*
	$('#SearchHisBtn').on('click',function(){
		reloadHisDicConGV('load');
	});*/
	//�س��¼�����his�ֵ估���չ�ϵ
	/*
	$('#SearchHisBox').on('keyup',function(event){
		var keycode = (event.keyCode ? event.keyCode : event.which);
		if(keycode!=13){
			return false;
		}
		reloadHisDicConGV('load');
	});*/
	
	//ҽ���ֵ��б����ݲ���
	/*
	$('#SearchMedBtn').on('click',function(){
		reloadInsuDicGV('load');
	});*/
	//�س��¼�����ҽ���ֵ��б���
	/*
	$('#SearchMedBox').on('keyup',function(event){
		var keycode = (event.keyCode ? event.keyCode : event.which);
		if(keycode!=13){
			return false;
		}
		reloadInsuDicGV('load');
	});*/
}

//��ѯ����
function doSearchDicConInfo(){
	reloadHisDicConGV('load');
}

//��ѯ�ֵ�
function doSearchDicInfo(){
	reloadInsuDicGV('load');
}

function setPageLayout(){
	//Ժ��������
	$('#HospitalBox').combobox({
		valueField:'code',
		textField:'desc'
		,onLoadSuccess:function(){
		}
		,onSelect:function(record){
			//alert(22);
		}
	})

	//ҽ������������
	$('#InsuTypeBox').combobox({
		//url:APP_PATH+"/INSUDictionaryContrast/GetDicDataList&DicKey=DLLType&ExtStr=",
		valueField:'diccode',
		textField:'dicdesc'
		,onLoadSuccess:function(){
			var $comboxObj=$('#InsuTypeBox');
			var data=$comboxObj.combobox('getData');
			if(data.length>0){
				var defaultVal=data[0].diccode;
				$comboxObj.combobox('setValue',defaultVal);
				//RefushGridViews();
			}
		}
		,onSelect:function(record){
			RefushGridViews();
		}
	})
	
	//��������
	$('#InsuConTypeBox').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: 'δ����'
		},{
			Code: '2',
			Desc: '�Ѷ���'
		},{
			Code: '3',
			Desc: 'ȫ��'
		}]
		,onSelect:function(record){
			RefushGridViews();
		}

	}); 
	$('#InsuConTypeBox').combobox('setValue',3);

	$('#HISInfoGV').datagrid({
		fit:true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20,30,50],
		frozenColumns: [[
		{field:"Check",checkbox:true},
		{field:'delCon',title:'��������',width:70
			,formatter:function(value,row,index){
				if(row.MedCode!=""){
					//return "<a style='width:60px;' class='dicconbtn hisui-linkbutton' data-options='plain:true' href='#' />";
					return "<a href='#' onclick='DelCon("+index+','+JSON.stringify(row)+")'>\
						<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/undo.png ' border=0/>\
						</a>";
				}else{
					return "";
				}
			}
		}]],
		columns: [[
		{field:'HisCode',title:'HIS����',width:100},
		{field:'HisDesc',title:'HIS����',width:130},
		{field:'MedCode',title:'ҽ������',width:100},
		{field:'MedDesc',title:'ҽ������',width:130}
		,{field:'UserNM',title:'������',width:120}
		,{field:'UpdateDt',title:'��������',width:100}
		,{field:'UpdateTime',title:'����ʱ��',width:100}
		,{field:'RowId',title:'����Dr',width:100,hidden:true}
		]]
		,onLoadSuccess:function(){
		}
		,onDblClickRow:function(rowIndex, rowData){    //˫��������չ�ϵ
			var RowId=rowData.RowId;    //����Dr
			if((RowId!="")&&(rowData.MedCode!="")){
				$.messager.confirm('��ܰ����', '��ȷ��Ҫɾ����ǰ�Ķ��չ�ϵ��', function(r){
					if (r){
						DeleteHisDicConDo(rowData);    //ɾ�����չ�ϵ��ajax����
					}
				});
			}
		}
		,onCheck:function(rowIndex,rowData){
			//alert("onCheck");
		}
		
	})

	//ҽ���ֵ���Ϣ
	$('#MedicalGV').datagrid({
		url:APP_PATH+"/INSUDictionaryContrast/GetINSUDicAjax",
		fit: true,
		border: false,
		pagination: true,
		rownumbers: true,
		pageSize:20,
		pageList:[20,50,100],
		columns:[[
		    {field:'dodo',title:'����',width:80
				,formatter:function(value,row,index){
					//return "<a style='width:50px;' title='��������' class='dicinfobtn hisui-linkbutton' data-options='plain:true' href='#' />";
					return "<a href='#' onclick='SaveCon("+index+','+JSON.stringify(row)+")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png ' border=0/>\
					</a>";
				}
			}
			,{field:'diccode',title:'ҽ������',width:120}
			,{field:'dicdesc',title:'ҽ������',width:160}
		]]
		,onLoadSuccess:function(){
			/*$('.dicinfobtn').linkbutton({
				iconCls: 'icon-compare'
			});*/
		}
		,onDblClickRow:function(rowIndex, rowData){    //˫��������չ�ϵ
			//SaveHisDicCon(rowData);           //һ��һ���淽ʽ
			SaveHisDicConMuti(rowData);      //һ�Զౣ�淽ʽ
		}
	})
	
}

function SaveHisDicConMuti(InsuRowData){
	var lens=0;
	var CheckedRecs=$('#HISInfoGV').datagrid('getChecked');      //GridView ѡ���������
	if((CheckedRecs!=null)&&(CheckedRecs!='undefined')){
		lens=CheckedRecs.length;
		if(lens==0){
			//alert('��ѡ������!');
			$.messager.alert("����ʾ", "��ѡ�����ݶ���!", "info");
			return "";
		}
	}else{
		$.messager.alert("����ʾ", "��ѡ�����ݶ���!", "info");
		return "";
	}
	
	var HisSelRowData=null;
	var tmpstr="";
	var WarnMessge="";
	var RowId="";
	var MedCode="";
	var hisDicDesc="";
	var ReSaveDataFlg="0";
	for(var i=0; i<lens; i++){
		HisSelRowData=CheckedRecs[i];
		
		RowId=HisSelRowData.RowId;        //������Ϣ�ı�Dr
		MedCode=HisSelRowData.MedCode;    //ҽ���ֵ����
		hisDicDesc=HisSelRowData.HisDesc;     //his�ֵ������
		/*if((RowId !="")&&(MedCode !="")){     //�Ѿ����չ����ֵ�
			if(confirm('����Ŀ�Ѿ����չ����Ƿ�Ҫ�� '+HisSelRowData.HisDesc+' ���¶��ճ� '+InsuRowData.dicdesc+' ��?')){
				SaveHisDicConDo(HisSelRowData, InsuRowData);    //������չ�ϵ��ajax����
			}else{
			}
			$.messager.confirm('��ܰ����', '��ǰ�ֵ��Ѿ����ڶ�����Ϣ����ȷ��Ҫ���¶�����', function(r){
				if (r){
					SaveHisDicConDo(CheckedRecs[HisSelRowData, InsuRowData);    //������չ�ϵ��ajax����
				}
			});
		}else{
			SaveHisDicConDo(HisSelRowData, InsuRowData);    //������չ�ϵ��ajax����
		}
		*/
		SaveHisDicConDoALL(HisSelRowData, InsuRowData);    //������չ�ϵ��ajax����
	}
}

///��ѯ���պ��ֵ������ֵ
function RefushGridViews(){
	reloadHisDicConGV('load');
	reloadInsuDicGV('load');
}

//����his�ֵ���ҽ���ֵ�Ķ��չ�ϵ
function SaveHisDicCon(InsuRowData){
	
	var HisSelRowData=$('#HISInfoGV').datagrid('getSelected');
	if(HisSelRowData==null){
		$.messager.alert("����ʾ", "��ѡ�����ݶ���!", "info");
		return 0;
	}
	var RowId=HisSelRowData.RowId;        //������Ϣ�ı�Dr
	var MedCode=HisSelRowData.MedCode;    //ҽ���ֵ����
	if((RowId !="")&&(MedCode !="")){
		$.messager.confirm('��ܰ����', '��ǰ�ֵ��Ѿ����ڶ�����Ϣ����ȷ��Ҫ���¶�����', function(r){
			if (r){
				SaveHisDicConDo(HisSelRowData, InsuRowData);    //������չ�ϵ��ajax����
			}else{
				return 0;
			}
		});
	}else{
		SaveHisDicConDo(HisSelRowData, InsuRowData);    //������չ�ϵ��ajax����
	}
}

function SaveHisDicConDoALL(HisSelRowData, InsuRowData){
	if(HisSelRowData.RowId !=""){ 
		$.messager.confirm('��ܰ����', '��ǰ�ֵ��Ѿ����ڶ�����Ϣ���Ƿ�Ҫ��  '+HisSelRowData.HisDesc+'  ���¶��ճ�  '+InsuRowData.dicdesc+'?', function(r){
			if (r){
				SaveHisDicConDo(HisSelRowData, InsuRowData);
			}else{
				return;
			}
		});
	}else{
		SaveHisDicConDo(HisSelRowData, InsuRowData);    //������չ�ϵ��ajax����
	}
}


////����˵����������չ�ϵ��ajax����
function SaveHisDicConDo(HisSelRowData, InsuRowData){
	var KeyCode=DicCode;                                                     //�ֵ�����ʶ����
	var InsuType=$('#InsuTypeBox').combobox('getValue');     //ҽ������
	var HospitalNo=PUBLIC_CONSTANT.SESSION.HOSPID; 
	/*if($("#hospitalDiv").is(":hidden")==false){
		HospitalNo=$('#HospitalBox').combobox('getValue');   //ҽԺ����
	}*/
	var HisCode=HisSelRowData.HisCode;          //HIS����
	var HisDesc=HisSelRowData.HisDesc;          //HIS����
	var diccode=InsuRowData.diccode             //ҽ������
	var dicdesc=InsuRowData.dicdesc             //ҽ������
	var userDr=LgUserID;                        //�û�Dr
	var ConInfo=HisCode+"^"+HisDesc+"^"+diccode+"^"+dicdesc+"^"+userDr+"^"+HospitalNo    //����ҽԺ���
	//alert("ConInfo="+ConInfo+"|KeyCode="+KeyCode+"|InsuType="+InsuType);
	
	$.post(
		APP_PATH+"/INSUDictionaryContrast/SaveDicConAjax",
		{
			KeyCode:KeyCode
			,InsuType:InsuType
			,HospitalNo:HospitalNo
			,ConInfo:ConInfo
		},
		function(data,textStatus){
			if(textStatus=="success"){
				if(data.status>0){
					reloadHisDicConGV('reload');
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
					//$.messager.show({title:'��ʾ',msg:'���ݱ���ɹ���',timeout:2000,showType:'slide'});
				}else{
					$.messager.alert('��ܰ����','������Ϣ����ʧ�ܣ�'+info);
				}
			}else{
				$.messager.alert('ϵͳ����','ϵͳ�쳣�����Ժ�����');
			}
		},
		'json'
	);
}

////����˵����ɾ��his�ֵ���ҽ���ֵ�Ķ��չ�ϵ
function DeleteHisDicConDo(rowData){
	var RowId=rowData.RowId;    //����Dr
	var ExtStr="";
	
	$.post(
		APP_PATH+"/INSUDictionaryContrast/DelDicConAjax",
		{
			RowId:RowId
			,ExtStr:ExtStr
		},
		function(data,textStatus){
			if(textStatus=="success"){
				if(data.status>0){
					reloadHisDicConGV('reload');
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
					//$.messager.show({title:'��ʾ',msg:'����ɾ���ɹ���',timeout:2000,showType:'slide'});
				}else{
					$.messager.alert('��ܰ����','������Ϣɾ��ʧ�ܣ�'+info);
				}
			}else{
				$.messager.alert('ϵͳ����','ϵͳ�쳣�����Ժ�����');
			}
		},
		'json'
	);
}

////����ҽ���ֵ伯���б�����
function reloadInsuDicGV(loadType){

	var KeyCode=DicCode;                                                     //�ֵ�����ʶ����
	var InsuType=$('#InsuTypeBox').combobox('getValue');     //ҽ������
	//var SearchKey=$('#SearchMedBox').val();                          //�����ؼ���
	var SearchKey=$('#SearchMedBox').searchbox('getValue');   //�����ؼ���
	var ExtStr=SearchKey+"^"+PUBLIC_CONSTANT.SESSION.HOSPID;
	//alert("KeyCode="+KeyCode+"|ExtStr"+ExtStr);
	
	//���¼��ز�ѯ���
	$('#MedicalGV').datagrid(loadType, {
		KeyCode:KeyCode
		,InsuType:InsuType
		,ExtStr:ExtStr
	});
	return 1;
}

////����his�ֵ����ݡ�ҽ�������Լ����������б�
function reloadHisDicConGV(loadType){
	
	var KeyCode=DicCode;                     //�ֵ�����ʶ����
	var classname=HisDicClass;              //his�ֵ��ȡ�������ڵ�����
	var methodname=HisDicMethod;     //his�ֵ��ȡ��������
	if((classname=="")||(classname=="")||(methodname=="")){
		//alert("����ϵ����Ա���������ֵ��ȡ�����Ժ��ٲ�ѯ");
		$.messager.alert("����ʾ", "����ϵ����Ա���������ֵ��ȡ�����Ժ��ٲ�ѯ!", "info");
		return 0;
	}

	var InsuType=$('#InsuTypeBox').combobox('getValue');     //ҽ������
	var HospitalNo=PUBLIC_CONSTANT.SESSION.HOSPID; 
	/*if($("#hospitalDiv").is(":hidden")==false){
		HospitalNo=$('#HospitalBox').combobox('getValue');   //ҽԺ����
	}*/
	//var SearchKey=$('#SearchHisBox').val();                    //�����ؼ���
	var SearchKey=$('#SearchHisBox').searchbox('getValue');   //�����ؼ���
	
	var InsuConType=$('#InsuConTypeBox').combobox('getValue');     //ҽ����������     add by xubaobao 2019 03 28
	//var ExtStr=classname+"^"+methodname+"^"+SearchKey;
	var ExtStr=classname+"^"+methodname+"^"+SearchKey+"^"+InsuConType;
	//alert("ExtStr="+ExtStr+"KeyCode="+KeyCode+"|InsuType="+"|HospitalNo="+HospitalNo);
	
	$('#HISInfoGV').datagrid('options').url = APP_PATH+"/INSUDictionaryContrast/GetHisDicAndConAjax";
	
	//���¼��ز�ѯ���
	$('#HISInfoGV').datagrid(loadType, {
		KeyCode:KeyCode
		,InsuType:InsuType
		,HospitalNo:HospitalNo
		,ExtStr:ExtStr
	});
	
	return 1;
}


//���÷������������������
function Import()
{
	var KeyCode=DicCode;
	var InsuType=$('#InsuTypeBox').combobox('getValue');     //ҽ������
	var HospitalNo=PUBLIC_CONSTANT.SESSION.HOSPID; 
	/*if($("#hospitalDiv").is(":hidden")==false){
		HospitalNo=$('#HospitalBox').combobox('getValue');   //ҽԺ����
	}*/
	importData(KeyCode,InsuType,HospitalNo);		 //insuimportdictionarycon.js
	reloadHisDicConGV('reload');
}
function selectHospCombHandle(){
	$('#InsuTypeBox').combobox('clear');
	var ExtStr = PUBLIC_CONSTANT.SESSION.HOSPID;  //����Ժ�� 20230314 JinS1010
	$('#InsuTypeBox').combobox('options').url = APP_PATH+"/INSUDictionaryContrast/GetDicDataList&DicKey=DLLType&ExtStr="+ExtStr;
	$('#InsuTypeBox').combobox('reload');
	//RefushGridViews();
	setTimeout(function(){
		doSearchDicInfo();
		doSearchDicConInfo();
	},300)
		
}
function SaveCon(index,rowDataInfo){
	//SaveHisDicCon(rowDataInfo);
	SaveHisDicConMuti(rowDataInfo);      //һ�Զౣ�淽ʽ*/	
}
function DelCon(index,rowDataInfo){
	$.messager.confirm('��ܰ����', '��ȷ��Ҫɾ����ǰ�Ķ��չ�ϵ��', function(r){
		if (r){
			DeleteHisDicConDo(rowDataInfo);    //ɾ�����չ�ϵ��ajax����
		}
	});
}