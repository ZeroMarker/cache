/**
 * FileName: insudlconfig.js
 * Anchor: Xubinbin
 * Date: 2020-03-04
 * Description:
 */
 var edit=0;
 var editIndex=-1;
 function BodyLoadHandler(){
	//��ʼ��ҳ��Ŀؼ�
	init();
 }
/**
 * @method init
 * @param 
 * @author xubinbin
 * Description: ҳ����صĳ�ʼ�����¼�������
 */
function init(){
	//��ʼ��ҽ�����������б�
	initInsuType();
	//��ʼ��ҵ������������б�
	initTableClsName();
	//DHCWeb_ComponentLayout();
	initTableList();
	//���밴ť�¼�
	/*
	$HUI.linkbutton('#import', {
		onClick: function () {
			Import_OnClick();
		}
	});
	*/
	$HUI.linkbutton('#find', {
		onClick: function () {
			loadDataList();
		}
	});
	$(document).keydown(function(e){
		 Doc_OnKeyDown(e);
	 });
}
/**
 * @method initInsuType
 * @param 
 * @author xubinbin
 * Description: ����ҽ������
 */
function initInsuType(){
	var id='insuType';	//������id
	var DicType="DLLType";  //ҽ�������ֵ����ͱ���Ϊ:DLLType
	initCombobox(id,DicType);
}

/**
 * @method initTableClsName
 * @param 
 * @author xubinbin
 * Description: ����ҵ��������
 */
function initTableClsName(){
	var id='TableClsName';	//������id
	var DicType="DownLoadBusinessList";  //ҽ�������ֵ����ͱ���Ϊ:DLLType
	initCombobox(id,DicType);
}
/**
 * @method Import_OnClick
 * @param 
 * @author xubinbin
 * Description: �����ĵ���¼�
 */
function Import_OnClick(){
	//alert(0)
	//alert($("#TableDataList").datagrid('getRows').length)
}




/**
 * @method initTableList
 * @param 
 * @author xubinbin
 * Description: ��ʼ�������б�
 */
function initTableList() {
	
	$HUI.datagrid('#TableDataList', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		rownumbers: true,
		fixRowHeight:90,
		url: $URL,
		pagination:true,
		pageSize:100,
		pageList:[100],
		columns: [[{
					title: '�����Ա���',
					field: 'ColProCode',
					align: 'left',
					width: 150
				}, {
					title: '��������',
					field: 'ColProName',
					align: 'left',
					width: 150
				}, {
					title: '���ܸ���',
					field: 'NotUpateFlg',
					align: 'center',
					width: 70,
					sortable:true,
					formatter: function (value, row, index) {
						return (value == "1") ? '<input  id="NotUpateFlg'+index+'" type="checkbox" onclick=\'changeChecked("NotUpateFlg",'+index+')\' data-options='+"checked:true"+' checked/>' : '<input class='+'hisui-checkbox'+' id="NotUpateFlg'+index+'" onclick=\'changeChecked("NotUpateFlg",'+index+')\'+ type="checkbox"/>';
					},
					sorter:function (a,b) { //�ù�ѡ�˵����ŵ�ǰ��
                   		return (a<b?1:-1);
                	}
				}, {
					title: '����ȽϹؼ���',
					field: 'CompareFlg',
					align: 'center',
					width: 120,
					sortable:true,
					formatter: function (value, row, index) {
						return (value == "1") ? '<input  type="checkbox" id="CompareFlg'+index+'" onclick=\'changeChecked("CompareFlg",'+index+')\' data-options='+"checked:true"+' checked/>' : '<input class='+'hisui-checkbox'+' id="CompareFlg'+index+'" onclick=\'changeChecked("CompareFlg",'+index+')\'  type="checkbox"/>';
					},
					sorter:function (a,b) { //�ù�ѡ�˵����ŵ�ǰ��
                   		return (a<b?1:-1);
                	}
				}, {
					title: '�ǿ���֤',
					field: 'NullCheckFlg',
					width: 70,
					align: 'center',
					sortable:true,
					formatter: function (value, row, index) {
						return (value == "1") ? '<input  type="checkbox" id="NullCheckFlg'+index+'" onclick=\'changeChecked("NullCheckFlg",'+index+')\' data-options='+"checked:true"+' checked/>' : '<input class='+'hisui-checkbox'+' id="NullCheckFlg'+index+'" onclick=\'changeChecked("NullCheckFlg",'+index+')\' type="checkbox"/>';
					},
					sorter:function (a,b) { //�ù�ѡ�˵����ŵ�ǰ��
                   		return (a<b?1:-1);
                	}
				}, {
					title: '��ʾ˳��',
					field: 'ShowIndexValue',
					width: 70,
					align: 'center',
					formatter: function (value, row, index) {
						var html='<img src="../images/u226.png"   style="width:19px;transform:rotate(90deg);height:11px" onclick="changeShowIndex('+index+',\'up\')"/>'
						html+='<img src="../images/u226.png"  style="width:19px;transform:rotate(270deg);height:11px" onclick="changeShowIndex('+index+',\'down\')"/>'
						return html;
					}
				}, {
					title: '��������',
					field: 'DataType',
					width: 90,
					formatter: function(value) {
						var returnValue=""
						switch(value) {
     						case "String":
        						returnValue="�ı�����";
        						break;
     						case "Date":
        						returnValue="��������";
        						break;
							case "Integer":
        						returnValue="��������";
        						break;
        					case "Time":
        						returnValue="ʱ������";
        						break;
     						default:
        						returnValue=value;
						} 
						return returnValue;
					},
					editor: {
						type: 'combobox',//������
						options: {
							valueField: 'DataType',//��ӦΪ����е�field
							textField: 'Text',//��ʾֵ
							editable: false,
							data: [
							{	DataType:"�ı�����",
								Text:"�ı�����"},
							{   DataType:"��������",
								Text:"��������"},
							{   DataType:"��������",
								Text:"��������"},
							{   DataType:"ʱ������",
								Text:"ʱ������"}
							]
						}
					}
					
				}, {
					title: '��ѡֵ',
					field: 'OptionVales',
					width: 150,
					align: 'left',
					editor: {
						type: 'text',//�ı���
						options: {
							required: false
						}
					}
					
				},{
					title: '����1',
					field: 'ExtStr1',
					align: 'left',
					width: 100,
					editor: {
						type: 'text',//�ı���
						options: {
							required: false
						}
					}
					
				},{
					title: '����2',
					field: 'ExtStr2',
					align: 'left',
					width: 100,
					editor: {
						type: 'text',//�ı���
						options: {
							required: false
						}
					}
					
				}, {
					title: '����3',
					field: 'ExtStr3',
					align: 'left',
					width: 100,
					editor: {
						type: 'text',//�ı���
						options: {
							required: false
						}
					}
					
				}, {
					title: '����4',
					field: 'ExtStr4',
					align: 'left',
					width: 70,
					editor: {
						type: 'text',//�ı���
						options: {
							required: false
						}
					}
					
				},{
					title: '����5',
					field: 'ExtStr5',
					align: 'left',
					width: 70,
					editor: {
						type: 'text',//�ı���
						options: {
							required: false
						}
					}
					
				}, {
					title: 'id',
					field: 'id',
					hidden: true,
					width: 100
					
				},{
					title: 'ShowIndex',
					field: 'ShowIndex',
					hidden: true,
					width: 100
					
				}
			]],
        onClickCell:function (rowIndex, field, value){  //������Ԫ��ʱ�������¼�
        	if(editIndex>-1)
        		getEditorValue(editIndex);
	        if(field=="OptionVales"||(field>="ExtStr1"&&field<="ExtStr5")||field=="OptionVales"||field=="DataType"){ //������õı༭���ĵ�Ԫ���ø��п��Ա༭
	        	$("#TableDataList").datagrid('beginEdit', rowIndex);
	        	edit=1;
	        }
	        //�������µı༭��
	        editIndex=rowIndex;
        }
	});
	
}
/**
 * @method changeShowIndex
 * @param 
 * @author xubinbin
 * Description: �ı��ֶε���ʾ˳��
 */
function changeShowIndex(index,flag){
	var Data=$("#TableDataList").datagrid('getData');  //�����ҳ����ص�����
	var length=Data.rows.length-1;
	var rows=Data.rows[index];   // �����Ҫ�����е�����
	var id=rows.id;
	if(flag=="up"&&index==0)  // �ڵ�һ���޷��ϵ�
			return ;
	if(flag=="down"&&index==length)// �����һ���޷��µ�
		    return ;
	if(flag=="up")
		switchRows(index-1,index)   //����Ҫ�ϵ�����index����index-1���н����͸��� 
	if(flag=="down")
		switchRows(index,index+1)  //����Ҫ�µ�����index����index+1���н����͸���
}
/**
 * @method switchRows
 * @param 
 * @author xubinbin
 * Description: ��������
 */
function switchRows(index,value){  // index : ��ʾ��ǰ��ģ� value����ʾ�ں����
	var Data=$("#TableDataList").datagrid('getData');
	var tmp=""
	var indexRows=Data.rows[index];
	var valueRows=Data.rows[value];
	//��Ҫ���������е���ʾ˳����н���
	tmp=indexRows.ShowIndex
	indexRows.ShowIndex=valueRows.ShowIndex 
	valueRows.ShowIndex=tmp
	//��ɾ����Ҫ����������
	$("#TableDataList").datagrid("deleteRow",index);
	$("#TableDataList").datagrid("deleteRow",value);
	//�ý������еķ�ʽ��datagrid������������
	$('#TableDataList').datagrid('insertRow',{
		index: index,	
		row: valueRows
	});
	$('#TableDataList').datagrid('insertRow',{
		index: value,	
		row: indexRows
	});
	//����̨�������е�����
	getEditorValue(index);
	getEditorValue(value);
	
}
/**
 * @method Doc_OnKeyDown
 * @param 
 * @author xubinbin
 * Description: ��ʼ���س��¼�
 */
function Doc_OnKeyDown(e)
{
	var key=websys_getKey(e);
	var eSrc=window.event.srcElement;
	if (key==13) {
		if(edit==0) //�жϱ༭���Ƿ���
			return 
		else{
			var selected=$("#TableDataList").datagrid("getSelected");  //��õ�ǰ������ж���
			var index=$("#TableDataList").datagrid('getRowIndex',selected);  //��ǰ�������ʾ����
			getEditorValue(index);
		}
			
	}
}
/**
 * @method changeChecked
 * @param 
 * @author xubinbin
 * Description: �����ѡ���¼�
 */
function changeChecked(field,index){
	var FlgObj=$("#"+field+index).prop("checked"); //��õ�ǰ��ѡ���ֵ
	var Data=$("#TableDataList").datagrid('getData');  //�����ҳ����ص�����
	var rows=Data.rows[index];   // �����Ҫ�����е�����
	rows.field=(FlgObj)?1:0  //��õ�ǰ��ѡ������ֶε�ֵ
	getEditorValue(index)
}
/**
 * @method getEditorValue
 * @param 
 * @author xubinbin
 * Description: ƴ����ҳ��ĸ���ֵ
 */
function getEditorValue(index){
	var exp=""
	var Data=$("#TableDataList").datagrid('getData');  //�����ҳ����ص�����
	var rows=Data.rows[index];   // �����Ҫ�����е�����
	var id=rows.id
	$("#TableDataList").datagrid('endEdit', index);  //�رտ����ı༭��
	//���ܸ����Ƿ�ѡ�� false :ûѡ�� true��ѡ��
	var NotUpateFlg=$("#NotUpateFlg"+index).prop("checked");  //���ܸ����Ƿ�ѡ�� false :ûѡ�� true��ѡ��
	var flag=(NotUpateFlg)?1:0
	exp="NotUpateFlg"+"!"+flag
	
	//����ȽϹؼ����Ƿ�ѡ�� false :ûѡ�� true��ѡ��
	var CompareFlg=$("#CompareFlg"+index).prop("checked");  
	flag=(CompareFlg)?1:0
	exp=exp+"^"+"CompareFlg"+"!"+flag
	
	//�ǿ���֤�Ƿ�ѡ�� false :ûѡ�� true��ѡ��
	var NullCheckFlg=$("#NullCheckFlg"+index).prop("checked");  //�ǿ���֤�Ƿ�ѡ�� false :ûѡ�� true��ѡ��
	flag=(NullCheckFlg)?1:0  
	exp=exp+"^"+"NullCheckFlg"+"!"+flag
	
	
	//����������͵������ı༭��
	var ShowIndex=rows.ShowIndex; //��ʾ˳���ֵ
	exp=exp+"^"+"ShowIndex"+"!"+ShowIndex
	
	//����������͵������ı༭��
	var DataType=(rows.DataType==undefined)?"":rows.DataType
	exp=exp+"^"+"DataType"+"!"+DataType
	
	//��ѡֵ�ı༭��
	var OptionVales=(rows.OptionVales==undefined)?"":rows.OptionVales
	exp=exp+"^"+"OptionVales"+"!"+OptionVales
	
	//��ѡ1�ı༭��
	var ExtStr1=(rows.ExtStr1==undefined)?"":rows.ExtStr1
	exp=exp+"^"+"ExtStr1"+"!"+ExtStr1
	 
	 //��ѡ2�ı༭��
	var ExtStr2=(rows.ExtStr2==undefined)?"":rows.ExtStr2
	exp=exp+"^"+"ExtStr2"+"!"+ExtStr2
	
	//��ѡ3�ı༭��
	var ExtStr3=(rows.ExtStr3==undefined)?"":rows.ExtStr3
	exp=exp+"^"+"ExtStr3"+"!"+ExtStr3
	
	//��ѡ4�ı༭��
	var ExtStr4=(rows.ExtStr4==undefined)?"":rows.ExtStr4
	exp=exp+"^"+"ExtStr4"+"!"+ExtStr4
	
	//��ѡ5�ı༭��
	var ExtStr5=(rows.ExtStr5==undefined)?"":rows.ExtStr5;
	exp=exp+"^"+"ExtStr5"+"!"+ExtStr5
	update(exp,id,index)
}

/**
 * @method update
 * @param 
 * @author xubinbin
 * Description: ��ǰ̨���º�̨����
 */
function update(exp,id,index){
	$m({
		ClassName:"web.InsuDlConfigCtl",
		MethodName:"updateInsuDlConfig",
		exp:exp,
		InsuDLConfigRowid:id
		},function(txtData){
		     edit=0;
		}
	);
}
 
/**
 * @method loadDataList
 * @param 
 * @author xubinbin
 * Description: ����datagrid
 */
function loadDataList() {
	var queryParams={
		ClassName: "web.InsuDlConfigCtl",
		QueryName: "GetInsuDLConfigInfo",
		InsuType: $("#insuType").combobox('getValue'),
		TableCode: $("#TableClsName").combobox('getValue')
	}
	$.extend($("#TableDataList")
	.datagrid('options'), {
		queryParams: queryParams
	});
	$("#TableDataList").datagrid("load");
}

// ��ѯҽ���ֵ��������(id:������id,DicType:�ֵ����ͱ���)
function initCombobox(id,DicType){
	$HUI.combobox('#'+id,{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	onBeforeLoad:function(param){
	   		param.ClassName="web.InsuTaritemsDLCtl"
	    	param.QueryName="QueryInsuDicDataInfo"
	   		param.ResultSetType="array"
	 		param.DicType=DicType       
	    },
	    onLoadSuccess:function(){
		    var Data= $('#'+id).combobox("getData");
		    var value=Data[0].DicCode
		    $('#'+id).combobox('setValue', value);
		    loadDataList();
		},
		onSelect: function(){
   		}
	});	
}
document.body.onload = BodyLoadHandler;