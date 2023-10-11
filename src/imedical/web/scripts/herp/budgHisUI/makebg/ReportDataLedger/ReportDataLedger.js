var hospid=session['LOGON.HOSPID'];

$(function(){//��ʼ��
    Initmain();
    $('#ReportCodeBox').val('');
    $('#ReportNameBox').val('')
}); 

  //����¼�
   function RoportDetail(value){
     var $reportwin;
     $reportwin = $('#winreport').window({
        width: 1100,
        height: 600,
        top: ($(window).height() - 600) * 0.5,
	    left: ($(window).width() - 1100) * 0.5,
        draggable:true,
        shadow: true,
        modal: true,
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        content  : '<iframe style="width:100%;height:100%" src="dhccpmrunqianreport.csp?reportName=herp.budg.hisui.report.'+value+'.raq" /></iframe>'
        })
        	 
	   $('#winreport').panel({title: value});
	   $('#winreport').window('open');
	   }
	   
 //���屨����
 
 
function Initmain(){	    
	MainColumns=[[{
	     field:'ReportTempletID',
	     hidden: true
	     },{
	     field:'CompDR',
	     hidden: true
	     },{
	     field:'ReportCode',
	     title:'�������',
	     width:150,
	     allowBlank:false,
	     required:true,
	     align:'left',
	     halign:'left',
	     },{
		 field:'ReportName',
		 title:'��������',
		 width:200,
		 align:'left',
		 allowBlank:false,
		 required:true,
		 halign:'left',
         formatter:function (value,row,index){
             return '<a href="#" onclick="RoportDetail(\''+row.ReportName+'\')" style="color:#017bce;cursor:hand;cursor:pointer;text-decoration:underline">'+row.ReportName+'</a>'}	 
	     },{
	     field:'ReportClass',
	     title:'�������',
	     width:100,
		 align:'center',
		 halign:'center',
		 formatter:comboboxFormatter,
		 editor:{
			 type:'combobox',
			 options:{
				 valueField:'rowid',
				 textField:'name',
				 data:[
				 {rowid:'1',name:'���ñ���'},
				 {rowid:'2',name:'�Զ���'}],
				 }}
	     },{
		 field:'ReortStatus',
         title:'����״̬',
         width:80,
		 align:'center',
		 halign:'center',
		 },{
	     field:'IsStop',
	     title:'�Ƿ�ͣ��',
	     width:80,
	     align:'center',
	     halign:'center',
	     editor:{type:'checkbox',options:{on:'1',off:'0'}},
	     formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },

	     },{
		 field:'IsRepMonth',
		 title:'�±�',
		 width:80,
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },
         editor:{type:'checkbox',options:{on:'1',off:'0'}}
		 },{
		 field:'IsRepSeason',
		 title:'����',
		 width:80, 
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },
		 editor:{type:'checkbox',options:{on:'1',off:'0'}}
		 },{
	     field:'IsRepHalf',
	     title:'���걨',
	     width:80,
	     align:'center',
	     halign:'center',
	     formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },
		 editor:{type:'checkbox',options:{on:'1',off:'0'}}
	     },{
		 field:'IsRepYear',
		 title:'�걨',
		 width:80,
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },
		 editor:{type:'checkbox',options:{on:'1',off:'0'}}
	     },{
	     field:'LinkFile',
	     title:'˵���ĵ�',
	     width:150,
	     align:'center',
	     halign:'center',
	     formatter:function(value,row,index){
		    return '<a href="#" class="SpecialClass"  title="����" data-options="iconCls:\'icon-attachment\'" onclick=attachment('+index+')></a>'}

		 }]]
		 
	var MainObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uReportTemplet",
            MethodName:"List",
        },
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: true, 
        nowrap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:MainColumns,
        onLoadSuccess:function(data){
            if(data){
                $('.SpecialClass').linkbutton({
                    plain:true
                })
            }
        }

        //onClickRow:onClickRow,
        });	 
		 
  // ��ѯ 
  $("#FindBtn").click(function(){
	    var ReportCode   = $('#ReportCodeBox').val()
        var ReportName   = $('#ReportNameBox').val()
     
        MainObj.load({
                ClassName: "herp.budg.hisui.udata.uReportTemplet",
                MethodName: "List",
                ReportCode : ReportCode,
                ReportName : ReportName,
                hospid: hospid
            })});
            		 
//���ɱ�������		 
  $("#MakeBtn").unbind('click').click(function(){
       MakeData(hospid); 
       		 
  })	 
}