var hospid = session['LOGON.HOSPID'];

$(function(){//��ʼ��
    Initmain();
    $('#ReportItemCodeBox').val('')
    $('#ReportItemNameBox').val('')
}); 
 
function Initmain(){
//��ϸ��
	DetailColumns=[[{
	     field:'ReportTempletDetailID',
	     hidden: true
	     },{
	     field:'ReportTempletID',
	     title:'��Ʊ���ģ��ID',
	     hidden: true
	     },{
		 field:'ReportItemCode',
		 title:'���������',
		 width:120,
		 align:'left',
		 halign:'left',
		 editor:{
		     type:'validatebox',
		     options:{
			     required:true,
			     validType:['a','b','c']
			     }}
		 },{
	     field:'ReportItemName',
	     title:'����������',
	     width:280,
		 align:'left',
		 halign:'left',
		 editor:{
		     type:'validatebox',
		     options:{
			     required:true}}
	     },{
		 field:'FormulaDesc',
		 title:'��Ŀ��ʽ����',
		 width:300,
		 align:'left',
		 halign:'left',
		 editor:{type:'text',}
		 },{
		 field:'FormulaCode',
         title:'��Ŀ��ʽ����',
         width:300,
		 align:'left',
		 halign:'left',
		 hidden:true,
		 editor:{type:'text'}	
		 },{
	     field:'RowNo',
	     title:'������',
	     width:80,
	     align:'center',
	     halign:'center',
	     editor:{type:'text'}
	     },{
		 field:'ColNO',
		 title:'������',
		 width:80,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'CompOrderNo',
		 title:'����˳��',
		 width:80,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'DispType',
		 title:'��ʾ����',
		 width:100, 
		 align:'left',
		 halign:'left',
		 formatter:comboboxFormatter,
		 editor:{
			 type:'combobox',
			 options:{
				 valueField:'rowid',
				 textField:'name',
				 data:[
				 {rowid:'0',name:'��ʾ'},
				 {rowid:'1',name:'����ʾ'}],
				 }}
	     },{
	     field:'DispDistribution',
	     title:'��ʾ����',
	     width:80,
	     align:'left',
	     halign:'left',
	     editor:{type:'text'}
		 },{
		 field:'InitValue',
		 title:'Ĭ��ֵ',
		 width:100,
		 align:'left',
		 halign:'left',
		 editor:{type:'text'}
		 }]]    
        
      var detailtableObj = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: true, 
        checkOnSelect : true,//�������Ϊ true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ���������Ϊ false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
        selectOnCheck : true,//�������Ϊ true�������ѡ�򽫻�ѡ�и��С��������Ϊ false��ѡ�и��н�����ѡ�и�ѡ��
        nowrap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        toolbar: '#dtb',
        columns:DetailColumns,
        })
        
         // ��ѯ 
  $("#DetailFindBtn").click(function(){
	  var row=$('#MainGrid').datagrid("getSelected");
	  if(row==null){
		  $.messager.popover({
		      msg:'����ѡ�񱨱�',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			         top:1}})
			         return;
		  }
	    var ReportItemCode   = $('#ReportItemCodeBox').val()
        var ReportItemName   = $('#ReportItemNameBox').val()
         
        detailtableObj.load({
                ClassName: "herp.budg.hisui.udata.uReportTemplet",
                MethodName: "DetailList",
                ReportTempletID:row.rowid, 
                ReportItemCode : ReportItemCode,
                ReportItemName : ReportItemName,
            })});
        
           
        }