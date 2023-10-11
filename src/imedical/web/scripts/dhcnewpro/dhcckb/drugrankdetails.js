
var drugId = "";
var catId = "";
var drug = "";
var pid = "";
var editRow = "";
var signArr = [{"value":"δ����","text":'δ����'},{"value":"complet","text":'������������'},{"value":"uwcomplet","text":'�������δ���'},{"value":"partcomp","text":'������󣬲������'},{"value":"partcompcon","text":'������󣬲�����ɣ����û�ȷ��'},{"value":"partcompproame","text":'������󣬲�����ɣ�����������'}, {"value":"partcompruleimp","text":'������󣬲�����ɣ������ƹ���'},{"value":"partcompdicimp","text":'������󣬲�����ɣ��������ֵ�'},{"value":"verifycorrect","text":'������ȷ������֤'},{"value":"affirmcorrect","text":'������ȷ�����û�ȷ��'},{"value":"achievecorrect","text":'������ȷ�������'}];
$(document).ready(function() {
	initParams();
    initDetailGrid();        //����ͳ������ 
    initCombobox();
    initButton(); 
})
function initParams()
{
		drugId = getParam("drugId");
		catId = getParam("catId");
		drug = getParam("drug");
		pid = getParam("pid");
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
		{field:'check',title:'sel',checkbox:true,hidden:false},
		{field:"patName",align:'center',width:100,title:"����",hidden:true},
		{field:"patNo",align:'center',width:100,title:"�ǼǺ�",hidden:true},
		{field:"sex",align:'center',width:80,title:"�Ա�",hidden:true},
		{field:"age",align:'center',width:100,title:"����",hidden:true},
		{field:"weight",align:'center',width:80,title:"����",hidden:true},
		{field:"hisAllergyList",align:'center',width:100,title:"����Դ",hidden:true},
		{field:"diagList",align:'center',width:300,title:"���",hidden:true},
		{field:"drugName",align:'center',width:300,title:"ҩƷ����"},
		{field:"drugNum",align:'center',width:80,title:"����ҩƷ����"},
		{field:"groupiden",align:'center',width:60,title:"��"},
		{field:"formProp",align:'center',width:80,title:"ҩƷ����",hidden:true},
		{field:"onceDose",align:'center',width:80,title:"���μ���",hidden:true},
		{field:"unit",align:'center',width:80,title:"������λ",hidden:true},
		{field:"drugFreq",align:'center',width:80,title:"Ƶ��",hidden:true},
		{field:"drugPreMet",align:'center',width:80,title:"��ҩ;��",hidden:true},
		{field:"treatment",align:'center',width:80,title:"�Ƴ�",hidden:true},
		{field:"drugOutParam",align:'left',width:450,title:"�����"},
		{field:"exasign",align:'center',width:160,title:"��˱��",editor:signeditor},
		{field:"remarks",align:'center',width:200,title:"��ע",editor:textEditor},
		{field:"exasignval",align:'center',width:100,title:"exasignval",editor:textEditor,hidden:true},
		{field:"funId",align:'center',width:60,title:"funId",hidden:true},
		{field:"deal",align:'center',width:115,title:"����",formatter:linkPrescdetails}
		
		
									
									
	]];
	
	///  ����datagrid
	var option = {
		//fitColumn:true,
		rownumbers : true,
		singleSelect : false,
		
		nowrap:false,  
		//fit : true,
		pageSize : [30],
		pageList : [30,60,90],
	 onDblClickRow: function (rowIndex, rowData) {
		       if (editRow != ""||editRow === 0){
			       			 
             $("#detailgrid").datagrid('endEdit', editRow); 

         } 
         $("#detailgrid").datagrid('beginEdit', rowIndex); 
         
         editRow = rowIndex;   
  },
  onLoadSuccess:function(data){
	  	
	 }
	    
	};
	var params = drugId +"^"+ catId +"^"+ $HUI.combobox("#sign").getValue()+"^"+ $HUI.combobox("#exares").getText();
	var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryPrescDetails&pid="+pid+"&params="+params;
	new ListComponent('detailgrid', columns, uniturl, option).Init();

}

function initCombobox()
{
	
	 //��˱��
		$HUI.combobox("#sign",{
					valueField:'value',
					textField:'text',
					panelHeight:"260",
					mode:'remote',
					data:signArr,
					onSelect:function(ret){
										
				 }
		 	})	
		 	
		 	//�������
		 	$HUI.combobox("#exares",{
					valueField:'value',
					textField:'text',
					panelHeight:"260",
					mode:'remote',
					onShowPanel:function(){
							var unitUrl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=GetCheckRes&pid="+pid;
							$("#exares").combobox('reload',unitUrl);
				}		   
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
				if(rowsData[i].monItmId==""){continue;}
				var tmp=rowsData[i].monItmId +"^"+ rowsData[i].remarks +"^"+ rowsData[i].exasignval ;
				dataList.push(tmp);
			} 
			var data=dataList.join("$$");
			console.log(data)
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
	var params = drugId +"^"+ catId +"^"+ $HUI.combobox("#sign").getValue() +"^"+ $HUI.combobox("#exares").getText();
	$('#detailgrid').datagrid('load',{'pid':pid,"params":params}); 
}
function resetPres()
{
	$HUI.combobox("#sign").setValue("");
	$HUI.combobox("#exares").setValue("");
	var params = drugId +"^"+ catId +"^"+ "" +"^"+ "" ;
	$('#detailgrid').datagrid('load',{'pid':pid,"params":params}); 
}

///ҩƷ��ϸ
function linkPrescdetails(value, rowData, rowIndex)
{
	
	var btn = "<img class='mytooltip' title='����' onclick=\"LoadPrescDetailsWin('"+rowData.monId+"','"+rowData.monItmId+"','"+rowData.funId+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  
}
function LoadPrescDetailsWin(monId,monItmId,funId){	
	if($('#windel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="windel"></div>');
	
	$('#windel').window({
		title:'���������Ϣ',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		width: window.screen.availWidth-80,
		height:window.screen.availHeight-150
	});
	
	var src= "dhcckb.reviewdetails.csp?monId="+monId+"&monItmId="+ monItmId+"&funId="+funId;
	var iframe='<iframe scrolling="yes" width=100% height=98%  frameborder="0" src='+src+'></iframe>';
	$('#windel').html(iframe);
	$('#windel').window('open'); 
	
}