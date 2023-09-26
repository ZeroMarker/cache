 /*
 * FileName: dhcbill.pkg.insudicitem.js
 * User:		LinCheng
 * Date:		2019-09-24
 * Function:	�ײ��ֵ���Ŀ����JS
 * Description: 
*/
//ȫ�ֱ���
//var HospDr=session['LOGON.HOSPID'];
var CreatUser=session['LOGON.USERID'];
var UpdateUser=session['LOGON.USERID'];
var tDicCode="";
var tmpselRow=-1;
var selRowid="";
var CreatDates="";
var CreatUsers="";
$(function(){
	QueryDic(); //�ֵ�����
	initPkgGrpList(); //�б�
	tclearform(); //����
	});
 

function QueryDic(){
$HUI.combogrid("#diccbx",{   //�ֵ�����
        panelWidth: 600,
        validType: ['checkInsuInfo'],
        delay: 300,
        mode: 'remote',
        method: 'GET',
        fitColumns: true,
        pagination: true,
        valueField:'KeyWords',
        textField:'DicDesc',
        data: [],
        columns: [
            [
             {field: 'DicCode', title: '�ֵ����ʹ���', width: 230},
             {field: 'DicDesc', title: '�ֵ���������', width: 230},
             {field: 'DicDemo', title: '��ע', width: 120}]
        ],
        url:$URL,
        defaultFilter:4,
        onBeforeLoad:function(para){
            para.ClassName='BILL.PKG.BL.Dictionaries'
            para.QueryName='QueryDicSys'
            para.KeyWords=para.q;
            para.AuthFlag = "";
            para.HospDr =PUBLIC_CONSTANT.SESSION.HOSPID;
            
        },    
        onLoadSuccess:function(){
        
        },
        onLoadError:function(err){
            
        },
        onSelect:function(Index, Data){
         tDicCode=Data.DicCode;
         initPkgGrpList();
        
        }    
    })


}




function initPkgGrpList() {  //�б�
	$HUI.datagrid("#dg",{
		url:$URL + "?ClassName=BILL.PKG.BL.Dictionaries&QueryName=QueryDic&DictType="+tDicCode+"&DicCode="+""+"&HospDr="+PUBLIC_CONSTANT.SESSION.HOSPID,
		fit: true,
		idField:'dgid',
		iconCls: 'icon-save',
		rownumbers:true,
		width: '100%',
		striped:true,
		fitColumns:true,
		singleSelect: true,
		autoRowHeight:false,
		columns:[[
			{field:'Id',title:'Rowid',width:10,hidden:true},
			{field:'Type',title:'�ֵ�����',width:150},
			{field:'Code',title:'����',width:150},
			{field:'Desc',title:'����',width:200},
			{field:'Mark',title:'��ע',width:150},
			{field:'CreatDate',title:'��������',width:150},
			{field:'CreatTime',title:'����ʱ��',width:100},
			{field:'UpdateDate',title:'�޸�����',width:150},
			{field:'UpdateTime',title:'�޸�ʱ��',width:100},
			{field:'CreatUserDr',title:'������DR',width:150,hidden:true},
			{field:'CreatUser',title:'������',width:150},
			{field:'UpdateUserDr',title:'�޸���DR',width:150,hidden:true},
			{field:'UpdateUser',title:'�޸���',width:150},
			{field:'Hospital',title:'ҽԺ',width:250},
			{field:'ActiveStatus',title:'��Ч��־',width:150,
			formatter:function(value,data,row){
					value=='Y'?value='��Ч':value='��Ч';
					return value;}
			
			},
		
		]],
		pageSize: 10,
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	      if(tmpselRow==rowIndex){
		        clearform("")
		        tmpselRow=-1
		        $(this).datagrid('unselectRow',rowIndex)
		    }else{
			    fillform(rowIndex,rowData)
			    tmpselRow=rowIndex
			}  
            
        },
        onselect: function(Index,Data) {
        	
        }
	});	
}

//���±����¼
function UpdateDic(){
     
	//�����ַ�^�Ĵ���
	$('#code').val($('#code').val().replace(/\^/g,""));
	$('#desc').val($('#desc').val().replace(/\^/g,""));
		
	if($('#code').val().indexOf("������")>=0 || $('#code').val()==""){$.messager.alert('��ʾ','��������Ϣ���ٱ���!');return;}
	if($('#desc').val().indexOf("������")>=0 || $('#desc').val()==""){$.messager.alert('��ʾ','���Ʋ���Ϊ��!');return;}
	if(CreatDates==""){
		var saveinfo=selRowid+"^"+$('#code').val()+"^"+$('#desc').val()+"^^^^^"+CreatUser+"^^"+$('#mark').val()+"^"+PUBLIC_CONSTANT.SESSION.HOSPID+"^"+tDicCode+"^"+"Y";
	//alert(saveinfo)
	var savecode=tkMakeServerCall("BILL.PKG.BL.Dictionaries","Save",saveinfo)
	
	if(savecode>0){
		$.messager.alert('��ʾ','����ɹ�!');  
		clearform("")
	
	}else{
		if(savecode==-1){
			$.messager.alert('��ʾ','��'+$('#code').val()+'���˴����Ѵ�����ͬ��¼!���Ҫ�����������Ȳ�ѯ���˴���ļ�¼!');  
			return; 
		}
		$.messager.alert('��ʾ','����ʧ��!');   
	}}
	else{
	var saveinfo=selRowid+"^"+$('#code').val()+"^"+$('#desc').val()+"^^^^^"+CreatUsers+"^"+UpdateUser+"^"+$('#mark').val()+"^"+PUBLIC_CONSTANT.SESSION.HOSPID+"^"+tDicCode+"^"+"Y";
	//alert(saveinfo)
	var savecode=tkMakeServerCall("BILL.PKG.BL.Dictionaries","Save",saveinfo)
	
	if(savecode>0){
		$.messager.alert('��ʾ','����ɹ�!');  
		clearform("")
	
	}else{
		if(savecode==-1){
			$.messager.alert('��ʾ','��'+$('#code').val()+'���˴����Ѵ�����ͬ��¼!���Ҫ�����������Ȳ�ѯ���˴���ļ�¼!');  
			return; 
		}
		$.messager.alert('��ʾ','����ʧ��!');   
	}}
	initPkgGrpList();
}

function tclearform() {
	//����
	$('#btnAdd').bind('click', function () {
	clearform("")	
});
}
//����±ߵ�form	
function fillform(rowIndex,rowData){
	selRowid=rowData.Id
	CreatDates=rowData.CreatDate
	CreatUsers=rowData.CreatUserDr
	$('#code').val(rowData.Code);
	$('#desc').val(rowData.Desc);
	$('#mark').val(rowData.Mark);
}
//����±ߵ�form
function  clearform(inArgs){
	$('#editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
	CreatDates="";
	CreatUsers="";
}
//�ı��±���ʾ��ı༭״̬
function disinput(tf){
	//return;
	$('#code').attr("disabled",tf);
	$('#desc').attr("disabled",tf);
	$('#mark').attr("disabled",tf);

}

// Ժ��combogridѡ���¼�
function selectHospCombHandle(){
	QueryDic(); //�ֵ�����
	initPkgGrpList(); //�б�
	tclearform(); //����

}