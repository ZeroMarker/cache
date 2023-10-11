var drugId = "";
var field = "";
var drug = "";
var itmId = "";
var editRow = "";    
var signArr = [{"value":"complet","text":'������������'},{"value":"uwcomplet","text":'�������δ���'},{"value":"partcomp","text":'������󣬲������'},{"value":"partcompcon","text":'������󣬲�����ɣ����û�ȷ��'},{"value":"partcompproame","text":'������󣬲�����ɣ�����������'}, {"value":"partcompruleimp","text":'������󣬲�����ɣ������ƹ���'},{"value":"partcompdicimp","text":'������󣬲�����ɣ��������ֵ�'},{"value":"verifycorrect","text":'������ȷ������֤'},{"value":"affirmcorrect","text":'������ȷ�����û�ȷ��'},{"value":"achievecorrect","text":'������ȷ�������'}];
$(document).ready(function() {
			 initParams();
    initDetailGrid();        //����ͳ������ 
    initCombobox();            //��������������
    initButton();              //���ذ�ť
})

function initParams()
{
		drugId = getParam("drugid");     //ҩƷid
		field = getParam("field");       //ҽԺid
		drug = getParam("drug");         //ҩƷ����
		itmId = getParam("itmId");       //��Ŀid
		$("#checkdrug").html(drug)
}


//���ؽ������
function initDetailGrid(){

	/// �ı��༭��
		var textEditor={
				type: 'text',//���ñ༭��ʽ
				options: {
					required: true //���ñ༭��������
				}
		}
	/// ���
	var signeditor={  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
				options: {
					data:signArr,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //���������߶��Զ�����
					onSelect:function(option){
								///��������ֵ
								var ed=$("#detailgrid").datagrid('getEditor',{index:editRow,field:'exasign'});
								$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
								var ed=$("#detailgrid").datagrid('getEditor',{index:editRow,field:'exasignval'});
								$(ed.target).val(option.value); 
					} 
		}
	}
	///  ����columns
	var columns=[[
			      {field:"monId",align:'center',width:100,title:"monId",hidden:true},
			      {field:"monItmId",align:'center',width:100,title:"monItmId",hidden:true},
			      {field:'check',title:'sel',checkbox:true},
		       {field:"patName",align:'center',width:100,title:"����"},
		       {field:"sex",align:'center',width:80,title:"�Ա�"},
		       {field:"age",align:'center',width:100,title:"����"},
			      {field:"weight",align:'center',width:80,title:"����"},
									{field:"hisAllergyList",align:'center',width:100,title:"����Դ"},
									{field:"diagList",align:'center',width:300,title:"���"},
									{field:"drugNum",align:'center',width:80,title:"����ҩƷ����"},
									{field:"groupiden",align:'center',width:60,title:"��"},
									{field:"drugName",align:'center',width:300,title:"ҩƷ����"},
									{field:"formProp",align:'center',width:80,title:"ҩƷ����"},
									{field:"onceDose",align:'center',width:80,title:"���μ���"},
									{field:"unit",align:'center',width:80,title:"������λ"},
									{field:"drugFreq",align:'center',width:80,title:"Ƶ��"},
									{field:"drugPreMet",align:'center',width:80,title:"��ҩ;��"},
									{field:"treatment",align:'center',width:80,title:"�Ƴ�"},
									{field:"drugOutParam",align:'left',width:450,title:"�����"},
									{field:"remarks",align:'center',width:200,title:"��ע",editor:textEditor},
									{field:"exasignval",align:'center',width:100,title:"exasignval",editor:textEditor,hidden:true},
									{field:"exasign",align:'center',width:160,title:"��˱��",editor:signeditor},
	]];
	
	///  ����datagrid
	var option = {
		rownumbers : true,
		singleSelect : false,
		nowrap:false,  
		pageSize : [30],
		pageList : [30,60,90],
	 onDblClickRow: function (rowIndex, rowData) {
		       if (editRow != ""||editRow === 0){
             $("#detailgrid").datagrid('endEdit', editRow); 
         } 
         $("#detailgrid").datagrid('beginEdit', rowIndex); 
         editRow = rowIndex;   
   },    	
	};
	
	var params = drugId +"^"+ field +"^"+ itmId  + "^" + $HUI.combobox("#sign").getValue();
	var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryProComplist&params="+params;
	new ListComponent('detailgrid', columns, uniturl, option).Init();

}

function initCombobox()
{
		$HUI.combobox("#sign",{
									valueField:'value',
									textField:'text',
									panelHeight:"260",
									mode:'remote',
									data:signArr,
									onSelect:function(ret){}
		 	})	
}

function initButton()
{
	$('#save').bind("click",saveRemark);
	$('#synchron').bind("click",synchron);
	$('#cancel').bind("click",cancelRemark);
	$('#find').bind("click",findPres);
	$('#reset').bind("click",resetPres);
}

//����ͬ��
function synchron(){
	 var rows = $('#detailgrid').datagrid('getSelections');  //ȡ������ѡ�������ݣ�����Ԫ�ؼ�¼����������
		if(rows.length>0)
		{
			   var remarks="";
			   var exasign="";
			   var exasignval="";
			   for(var i=0; i<rows.length; i++){
								  if(remarks==""){
								     remarks=rows[i].remarks;
								  }
								  if(exasignval==""){
								     exasignval=rows[i].exasignval;
								  }
								  if(exasign==""){
								     exasign=rows[i].exasign;
								  }
							}
							if(remarks==""&&exasign==""&&exasignval==""){
													   $.messager.alert("��ʾ","����дһ������");
													   return;
						 }else{
								  for(var i=0; i<rows.length; i++){
									   
								     rows[i].remarks=remarks;
								     rows[i].exasign=exasign;
								     rows[i].exasignval=exasignval;
								     $("#detailgrid").datagrid('beginEdit', i); 
								     editRow = i;
								  }
						}	
		} 
		saveRemarksel();
}

function saveRemarksel()
{
	
			var rowsData = $("#detailgrid").datagrid('getSelections');
			
			for(var i=0; i<rowsData.length; i++){
				 $("#detailgrid").datagrid('endEdit', i);
				}
			
			
			if(rowsData.length<=0){
				$.messager.alert("��ʾ","û�д���������!");
				return;
			}
			var dataList = [];
			for(var i=0;i<rowsData.length;i++){
				var tmp=rowsData[i].monItmId +"^"+ rowsData[i].remarks +"^"+ rowsData[i].exasignval ;
				dataList.push(tmp);
			} 
			var data=dataList.join("$$");
			//��������
			runClassMethod("web.DHCCKBCalculateval","saveRemark",{"dataList":data},function(jsonString){
						$('#detailgrid').datagrid('reload'); //���¼���
			});
}

function saveRemark()
{
	
			if(editRow>="0"){
				$("#detailgrid").datagrid('endEdit', editRow);
			}

			var rowsData = $("#detailgrid").datagrid('getChanges');
			if(rowsData.length<=0){
				$.messager.alert("��ʾ","û�д���������!");
				return;
			}
			var dataList = [];
			for(var i=0;i<rowsData.length;i++){
				var tmp=rowsData[i].monItmId +"^"+ rowsData[i].remarks +"^"+ rowsData[i].exasignval ;
				dataList.push(tmp);
			} 
			var params=dataList.join("$$");
			//��������
			runClassMethod("web.DHCCKBCalculateval","saveRemark",{"dataList":params},function(jsonString){
						$('#detailgrid').datagrid('reload'); //���¼���
			});
}

function cancelRemark()
{
	var rowsData = $("#detailgrid").datagrid('getSelected'); //ѡ��Ҫɾ������
}

function findPres()
{
	var params = drugId +"^"+ field +"^"+ itmId  + "^" + $HUI.combobox("#sign").getValue();
	$('#detailgrid').datagrid('load',{"params":params}); 
}
function resetPres()
{
	$HUI.combobox("#sign").setValue("");
	var params = drugId +"^"+ field +"^"+ itmId  + "^" + $HUI.combobox("#sign").getValue();
	$('#detailgrid').datagrid('load',{"params":params}); 
}