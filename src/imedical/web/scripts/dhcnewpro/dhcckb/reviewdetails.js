
var monId = "";
var monItmId = "";
var funId = "";
$(document).ready(function() {
	initParams();
    initDetailGrid();        //����ͳ������  
})
function initParams()
{
		monId = getParam("monId");
		monItmId = getParam("monItmId");
		funId = getParam("funId");
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
		
	///  ����columns
	var columns=[[
	
		{field:"monId",align:'center',width:100,title:"monId",hidden:true},
		{field:"monItmId",align:'center',width:100,title:"monItmId",hidden:true},
		{field:'check',title:'sel',checkbox:true,hidden:true},
		{field:"patName",align:'center',width:100,title:"����"},
		{field:"patNo",align:'center',width:100,title:"�ǼǺ�"},
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
		{field:"exasign",align:'center',width:160,title:"��˱��"},
		{field:"funId",align:'center',width:60,title:"funId",hidden:true},
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
	
	var uniturl = $URL+"?ClassName=web.DHCCKBReviewDetails&MethodName=QueryRevDetails&monItmList="+monItmId+"&funId="+funId;
	new ListComponent('detailgrid', columns, uniturl, option).Init();

}
