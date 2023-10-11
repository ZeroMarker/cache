var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
$(function () { //��ʼ��
	Init();
});

function Init() {
	//���������
	var YMboxObj = $HUI.combobox("#YMbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			onBeforeLoad: function (param) {
				param.str = param.q;
			},
			onSelect:function(data){ 
	        $('#Itemnamebox').combobox('clear'); //���ԭ��������
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&year="+data.year;
	        $('#Itemnamebox').combobox('reload',Url);//���������б�����
	        $('#ProjNamebox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=projName&hospid="+hospid+"&userdr="+userid+"&year="+data.year;
	        $('#ProjNamebox').combobox('reload',url);//���������б�����
	        //console.log(JSON.stringify(data));
	        var Year = $('#YMbox').combobox('getValue'); // �������
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // ���ο���
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // Ԥ���Ŀ
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // ��Ŀ����
		    var FundType = $('#FundTypebox').combobox('getValue'); // �ʽ����
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // Ԥ�����
		    var State = $('#Statebox').combobox('getValue'); // ״̬
	        MainGridObj.load({
		            ClassName: "herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
			        MethodName: "List",
					hospid: hospid,
			        year: Year,
			        userid: userid,
			        dutydeptdr:DutydeptName,
			        projdr:ProjName,
			        fundtype:FundType,
			        deptdr:DeptDR,
			        itemcode:Itemname,
			        state:State
				})
           }
		});
	// ���ο��ҵ�������
	var DutyDRObj = $HUI.combobox("#DutydeptNamebox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 3;
				param.str = param.q;
			},onSelect:function(data){
			$('#Itemnamebox').combobox('clear'); //���ԭ��������
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&deptdr="+data.rowid;
	        $('#Itemnamebox').combobox('reload',Url);//���������б�����
	        var Year = $('#YMbox').combobox('getValue'); // �������
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // ���ο���
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // Ԥ���Ŀ
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // ��Ŀ����
		    var FundType = $('#FundTypebox').combobox('getValue'); // �ʽ����
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // Ԥ�����
		    var State = $('#Statebox').combobox('getValue'); // ״̬
	        MainGridObj.load({
		            ClassName: "herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
			        MethodName: "List",
					hospid: hospid,
			        year: Year,
			        userid: userid,
			        dutydeptdr:DutydeptName,
			        projdr:ProjName,
			        fundtype:FundType,
			        deptdr:DeptDR,
			        itemcode:Itemname,
			        state:State
				})
			}
		});
		//�ʽ����������
		var FundTypeObj=$HUI.combobox("#FundTypebox",{
			url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
			mode: 'remote',
			delay: 200,
			valueField: 'fundTypeId',
			textField: 'fundTypeNa',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.str = param.q;
			},onSelect:function(data){
			var Year = $('#YMbox').combobox('getValue'); // �������
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // ���ο���
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // Ԥ���Ŀ
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // ��Ŀ����
		    var FundType = $('#FundTypebox').combobox('getValue'); // �ʽ����
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // Ԥ�����
		    var State = $('#Statebox').combobox('getValue'); // ״̬
	        MainGridObj.load({
		            ClassName: "herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
			        MethodName: "List",
					hospid: hospid,
			        year: Year,
			        userid: userid,
			        dutydeptdr:DutydeptName,
			        projdr:ProjName,
			        fundtype:FundType,
			        deptdr:DeptDR,
			        itemcode:Itemname,
			        state:State
				})
			}
			});
		//״̬
		var StateObj = $HUI.combobox("#Statebox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        onSelect:function(data){
			var Year = $('#YMbox').combobox('getValue'); // �������
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // ���ο���
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // Ԥ���Ŀ
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // ��Ŀ����
		    var FundType = $('#FundTypebox').combobox('getValue'); // �ʽ����
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // Ԥ�����
		    var State = $('#Statebox').combobox('getValue'); // ״̬
	        MainGridObj.load({
		            ClassName: "herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
			        MethodName: "List",
					hospid: hospid,
			        year: Year,
			        userid: userid,
			        dutydeptdr:DutydeptName,
			        projdr:ProjName,
			        fundtype:FundType,
			        deptdr:DeptDR,
			        itemcode:Itemname,
			        state:State
				})
			},
        data: [{
                    'rowid': "0",
                    'name': "�½�"
                },{
                    'rowid': "1",
                    'name': "�ύ"
               },{
	               'rowid': "2",
                    'name': "�ѻ���"
               },{
                    'rowid': "3",
                    'name': "��ͬ�����"
               }]
        });
		
		//Ԥ�����������
		var DeptDRObj = $HUI.combobox("#DeptDRbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 2;
				param.str = param.q;
			},onSelect:function(data){
			var Year = $('#YMbox').combobox('getValue'); // �������
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // ���ο���
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // Ԥ���Ŀ
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // ��Ŀ����
		    var FundType = $('#FundTypebox').combobox('getValue'); // �ʽ����
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // Ԥ�����
		    var State = $('#Statebox').combobox('getValue'); // ״̬
	        MainGridObj.load({
		            ClassName: "herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
			        MethodName: "List",
					hospid: hospid,
			        year: Year,
			        userid: userid,
			        dutydeptdr:DutydeptName,
			        projdr:ProjName,
			        fundtype:FundType,
			        deptdr:DeptDR,
			        itemcode:Itemname,
			        state:State
				})
			}
			
		});
		
		//Ԥ���Ŀ������
		var ItemnameObj = $HUI.combobox("#Itemnamebox", 
		{
			url: $URL + "?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
			param.hospid = hospid;
            param.year 	 = $('#YMbox').combobox('getValue');
            param.deptdr = $('#DutydeptNamebox').combobox('getValue');
            param.str 	 = param.q;
			},onSelect:function(data){
			var Year = $('#YMbox').combobox('getValue'); // �������
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // ���ο���
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // Ԥ���Ŀ
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // ��Ŀ����
		    var FundType = $('#FundTypebox').combobox('getValue'); // �ʽ����
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // Ԥ�����
		    var State = $('#Statebox').combobox('getValue'); // ״̬
	        MainGridObj.load({
		            ClassName: "herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
			        MethodName: "List",
					hospid: hospid,
			        year: Year,
			        userid: userid,
			        dutydeptdr:DutydeptName,
			        projdr:ProjName,
			        fundtype:FundType,
			        deptdr:DeptDR,
			        itemcode:Itemname,
			        state:State
				})
			},onShowPanel:function(){
        	if($('#YMbox').combobox('getValue')==""){
        		$(this).combobox('hidePanel');
        		$.messager.popover({
					msg: '����ѡ����ȣ�',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
        		return false;
        	}
        }
		});
		
		//��Ŀ����������
		var ProjNameObj = $HUI.combobox("#ProjNamebox", 
		{
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=projName",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.year=$("#YMbox").combobox('getValue');
				param.str = param.q;
			},onSelect:function(data){
			var Year = $('#YMbox').combobox('getValue'); // �������
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // ���ο���
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // Ԥ���Ŀ
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // ��Ŀ����
		    var FundType = $('#FundTypebox').combobox('getValue'); // �ʽ����
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // Ԥ�����
		    var State = $('#Statebox').combobox('getValue'); // ״̬
	        MainGridObj.load({
		            ClassName: "herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
			        MethodName: "List",
					hospid: hospid,
			        year: Year,
			        userid: userid,
			        dutydeptdr:DutydeptName,
			        projdr:ProjName,
			        fundtype:FundType,
			        deptdr:DeptDR,
			        itemcode:Itemname,
			        state:State
				})
			},onShowPanel:function(){
        	if($('#YMbox').combobox('getValue')==""){
        		$(this).combobox('hidePanel');
        		$.messager.popover({
					msg: '����ѡ����ȣ�',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
        		return false;
        	}
        }
		});
		
	 MainColumns=[[  
                {field:'ck',checkbox:true},//��ѡ��
                {field:'rowid',title:'��ϸID',width:80,hidden: true},
                {field:'projadjdr',title:'����ID',width:80,hidden: true},
                {field:'fundtypedr',title:'�ʽ����ID',width:80,hidden: true},
                {field:'fundtype',title:'�ʽ����',width:120},
                {field:'projName',title:'��Ŀ����',width:220},
                {field:'itemcode',title:'��Ŀ����',width:80,hidden: true},
                {field:'bidlevel',title:'Ԥ�㼶��',width:80,hidden: true},
                {field:'itemname',title:'��Ŀ����',width:220},
                {field:'deptDR',title:'Ԥ�����',width:80,hidden: true},
                {field:'deptName',title:'Ԥ�����',width:120},
                {field:'bidislast',title:'�Ƿ�ĩ��',width:80,hidden: true},
                {field:'budgprice',title:'Ԥ�㵥��',align:'left',width:180,
		    	    formatter:function(value,row,index){
		                 if(value>0){
		                 	return '<span>' + (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,') + '</span>';
		                 }
		            }
		    	},
                {field:'budgnum',title:'Ԥ������',align:'left',width:100},
                {field:'budgpro',title:'��Ԥ��ռ��(%)',align:'left',width:120},
                {field:'budgvalue',title:'Ԥ����',align:'left',width:180,
		    	    formatter:function(value,row,index){
		                 if(value>0){
		                 	return '<span>' + (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,') + '</span>';
		                 }
		            }
		    	},
                {field:'isaddedit',title:'����/����',width:80},
                {field:'dutydeptDR',title:'���ο���ID',width:100,hidden: true},
                {field:'dutydeptName',title:'���ο���',width:120},
                {field:'State',title:'״̬',width:60},
                {field:'SSUSRName',title:'������',width:80,hidden: true},
                {field:'isaudit',title:'�з����Ȩ��',width:150,hidden: true},
                {field:'projState',title:'��Ŀ״̬',width:120,hidden: true},
                {field:'budgdesc',title:'�豸���Ʊ�ע',width:120},
                {field:'PerOrigin',title:'��Ա����-ԭ���豸',width:150},
                {field:'FeeScale',title:'�շѱ�׼',width:120},
                {field:'AnnBenefit',title:'��Ч��Ԥ��',width:120},
                {field:'MatCharge',title:'�Ĳķ�',width:80},
                {field:'SupCondit',title:'��������',width:120},
                {field:'Remarks',title:'��ע',width:120},
                {field:'brand1',title:'�Ƽ�Ʒ��1',width:120},
                {field:'spec1',title:'����ͺ�1',width:120},
                {field:'brand2',title:'�Ƽ�Ʒ��2',width:120},
                {field:'spec2',title:'����ͺ�2',width:120},
                {field:'brand3',title:'�Ƽ�Ʒ��3',width:120},
                {field:'spec3',title:'����ͺ�3',width:120}
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
            MethodName:"List",
            hospid :    hospid, 
            userid :    userid,
            year   : 	"",
            dutydeptdr :"",
            projdr: 	"",
            fundtype : 	"",
            itemcode: 	"",
            deptdr: 	""
        },
			fitColumns: false, //�й̶�
			loadMsg: "���ڼ��أ����Եȡ�",
			autoRowHeight: true,
			rownumbers: true, //�к�
			ctrlSelec: true, //�����ö���ѡ���ʱ������ʹ��Ctrl��+������ķ�ʽ���ж�ѡ����
			// singleSelect: true, //ֻ����ѡ��һ��
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100], //ҳ���Сѡ���б�
			pagination: true, //��ҳ
			fit: true,
			columns: MainColumns,
			rowStyler: function (index, row) {
				if (row.State == "�ύ") {
					return 'background-color:#F0FFFF;';
				}if (row.State == "�ѻ���") {
					return 'background-color:#FFF0F5;';
				}
			},
			toolbar: '#tb'
		});
		
		 
			//JSON.stringify(rows)
	//��ѯ����
	var FindBtn = function () {
		var Year = $('#YMbox').combobox('getValue'); // �������
		var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // ���ο���
		var Itemname = $('#Itemnamebox').combobox('getValue'); // Ԥ���Ŀ
		var ProjName = $('#ProjNamebox').combobox('getValue'); // ��Ŀ����
		var FundType = $('#FundTypebox').combobox('getValue'); // �ʽ����
		var DeptDR = $('#DeptDRbox').combobox('getValue'); // Ԥ�����
		var State = $('#Statebox').combobox('getValue'); // ״̬
		MainGridObj.load({
			ClassName: "herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
			MethodName: "List",
			hospid: hospid,
			year: Year,
			userid: userid,
			dutydeptdr:DutydeptName,
			projdr:ProjName,
			fundtype:FundType,
			deptdr:DeptDR,
			itemcode:Itemname,
			state:State
		})
	}
	
	//�����ѯ��ť
	$("#FindBn").click(FindBtn);
	function ChkPef(){
	if(($('#BDutybox').combobox('getValue')=="")||($('#BDeptbox').combobox('getValue')=="")||($('#BItembox').combobox('getValue')=="")||($('#BAEbox').combobox('getValue')=="")||($('#BNumbox').val()=="")||($('#BPricebox').val()=="")){
		$.messager.popover({
					msg: '��ѡ���Ϊ�գ�',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				});
				return false;
	}
	return true;	
	}
	//����
	var AddBtn=function(){	
		var $win; 
		$("#Detailff").form('clear');
		$win = $('#Add').window({
				title: '�����Ŀ��ϸ��Ϣ',
				width: 800,
				height: 575,
				top: ($(window).height() - 600) * 0.5,
				left: ($(window).width() - 900) * 0.5,
				shadow: true,
				modal: true,
				iconCls: 'icon-add',
				closed: true,
				minimizable: false,
				maximizable: false,
				collapsible: false,
				resizable: true,
				onClose: function () { //�رչرմ��ں󴥷�
					$("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
				}
			});
		$win.window('open');
		// ��ȵ�������
    var AddYearObj = $HUI.combobox("#BYMbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        value: new Date().getFullYear(),
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect:function(data){
	        $('#BItembox').combobox('clear'); //���ԭ��������
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&year="+data.year;
	        $('#BItembox').combobox('reload',Url);//���������б�����
        }
    });
    // ���ο��ҵ�������
    var AddDeptObj = $HUI.combobox("#BDutybox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 3;
            param.str = param.q;
        },onSelect:function(data){
			$('#BItembox').combobox('clear'); //���ԭ��������
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&deptdr="+data.rowid;
	        $('#BItembox').combobox('reload',Url);//���������б�����
			}
    });
    // Ԥ����ҵ�������
    var AddBgDeptObj = $HUI.combobox("#BDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.str = param.q;
        }
    });
    // Ԥ���Ŀ��������
    var AddItemObj = $HUI.combobox("#BItembox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.year 	 = $('#BYMbox').combobox('getValue');
            param.deptdr = $('#BDutybox').combobox('getValue');
            param.str 	 = param.q;
        },
        onShowPanel:function(){
        	if($('#BYMbox').combobox('getValue')==""){
        		$(this).combobox('hidePanel');
        		$.messager.popover({
					msg: '����ѡ����ȣ�',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				});
        		return false;
        	}
        }
    });
    // �ʽ����͵�������
    var AddFundTyObj = $HUI.combobox("#BFundTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ListFundType",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.str = param.q;
        }
    });
    // ����-���µ�������
    var AddAEObj = $HUI.combobox("#BAEbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': 1,
                    'name': "����"
                },{
                    'rowid': 2,
                    'name': "����"
        }]
     });
    //Ԥ�㵥�۱仯������Ԥ����
    $('#BPricebox').keyup(function(event){
    	Calcu();
    })
    //Ԥ�������仯������Ԥ����
    $('#BNumbox').numberspinner({
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }) 
    //����Ԥ���� = ����*���� 
    function Calcu(){
    	var AddPrice = parseFloat($('#BPricebox').val());  //Ԥ�㵥��
    	if (AddPrice ==""||isNaN(AddPrice)){AddPrice = 0};
    	var AddNum = parseFloat($('#BNumbox').val()); //Ԥ������
    	if (AddNum ==""||isNaN(AddNum)){AddNum = 0};
    	$('#BSumbox').val(AddPrice.toFixed(2)*AddNum.toFixed(0));
    }
    //��ӷ��� 
    $("#BtchSave").unbind('click').click(function(){
	    var dutydeptdr=$('#BDutybox').combobox('getValue');
        var itemcode = $('#BItembox').combobox('getValue');//Ԥ���Ŀ
		var budgprice = $('#BPricebox').val();
		var budgnum = $('#BNumbox').val();
		var budgdesc = $('#BEquRemarkbox').val();  //�豸����
		var FeeScale = $('#BFeeScabox').val();     //�շѱ�׼
		var AnnBenefit = $('#BAnnBenbox').val();   //��Ч��Ԥ��
		var MatCharge = $('#BMatCharbox').val();   //�Ĳķ�
		var SupCondit = $('#BSupConbox').val();    //��������
		var Remarks = $('#BRemarkbox').val();      //˵��
		var brand1 = $('#BBrand1box').val();		  //�Ƽ�Ʒ��1
		var spec1 = $('#BSpec1box').val();		  //����ͺ�1
		var brand2 = $('#BBrand2box').val();		  //�Ƽ�Ʒ��2
		var brand3 = $('#BBrand3box').val();		  //�Ƽ�Ʒ��3
		var spec3 = $('#BSpec3box').val();		  //����ͺ�3
		var spec2 = $('#BSpec2box').val();		  //����ͺ�2
		var isaddedit = $('#BAEbox').combobox('getValue');  //����-����
		var PerOrigin = $('#BPerOribox').val();  //��Ա����-ԭ���豸
		var fundtype = $('#BFundTypebox').combobox('getValue');  //�ʽ����� 
		var budgpro = $('#BPercebox').val();   //��Ԥ��ռ��
		var deptdr = $('#BDeptbox').combobox('getValue');
		if(ChkPef()==true){
		var datad = itemcode + '|' + budgprice + '|' + budgnum + '|' + budgdesc
			 + '|' + FeeScale + '|' + AnnBenefit + '|' + MatCharge + '|' + SupCondit + '|' + Remarks + '|'
			+brand1 + '|' + spec1 + '|' + brand2 + '|' + spec2 + '|' + brand3 + '|' + spec3 + '|' + isaddedit + "|" + PerOrigin
			 + "|" + fundtype + '|' + budgpro + '|' + userid + '|' + deptdr + '|' + hospid;
			 
        $.m({
            ClassName:'herp.budg.udata.uBudgProjEstablishDetailToPrj',MethodName:'Insert',data:datad},
            function(Data){
                if(Data==0){
                    $.messager.popover({
					msg: "����ɹ���",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
          
                }
            }
        );
        $win.window('close');
        }
    });

    $("#BtchClose").unbind('click').click(function(){
        $win.window('close');
    });
    }
	//���������ť
	$("#AddBn").click(AddBtn);
	//�޸�
	var UpdaBtn=function(){
	var rowObj = $('#MainGrid').datagrid('getSelected');
	var rows = $('#MainGrid').datagrid('getSelections');
	if(rows.length!=1){
	$.messager.popover({
					msg: '��ѡ��һ�������޸�!',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
				return false;
	}
	if(rowObj.State!="�½�"){
		$.messager.popover({
					msg: '��Ȩ���޸ķǡ��½���״̬���ݣ�',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
				return false;
	}
		$("#Detailff").form('clear');
		var $win; 
		$win = $('#Add').window({
				title: '�޸���Ŀ��ϸ��Ϣ',
				width: 800,
				height: 575,
				top: ($(window).height() - 600) * 0.5,
				left: ($(window).width() - 900) * 0.5,
				shadow: true,
				modal: true,
				iconCls: 'icon-write-order',
				closed: true,
				minimizable: false,
				maximizable: false,
				collapsible: false,
				resizable: true,
				onClose: function () { //�رչرմ��ں󴥷�
					$("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
				}
			});
		$win.window('open');
    var rowid = rowObj.rowid;
    var tmpitemcode = rowObj.itemcode;
    var tmpbudgprice = rowObj.budgprice;
    var tmpbudgnum = rowObj.budgnum;
    var tmpbudgdesc = rowObj.budgdesc;
    var tmpFeeScale = rowObj.FeeScale;
    var tmpAnnBenefit = rowObj.AnnBenefit;
    var tmpMatCharge = rowObj.MatCharge;
    var tmpSupCondit = rowObj.SupCondit;
    var tmpRemarks = rowObj.Remarks;
    var tmpbrand1 = rowObj.brand1;
    var tmpspec1 = rowObj.spec1;
    var tmpbrand2 = rowObj.brand2;
    var tmpspec2 = rowObj.spec2;
    var tmpbrand3 = rowObj.brand3;
    var tmpspec3 = rowObj.spec3;
    var tmpisaddedit = rowObj.isaddedit;
    if (tmpisaddedit == "����") {
        tmpisaddedit = 1;
    }
    if (tmpisaddedit == "����") {
        tmpisaddedit = 2;
    }
    var tmpPerOrigin = rowObj.PerOrigin;
    var tmpfundtype = rowObj.fundtypedr;
    var tmpbudgpro = rowObj.budgpro;
    var tmpbudgvalue = rowObj.budgvalue;
    var tmpdeptdr = rowObj.deptDR;
    // ��ȵ�������
    var UpdaYearObj = $HUI.combobox("#BYMbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        value: new Date().getFullYear(),
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect:function(data){
	        $('#BItembox').combobox('clear'); //���ԭ��������
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&year="+data.year;
	        $('#BItembox').combobox('reload',Url);//���������б�����
        }
    });
    // ���ο��ҵ�������
    var UpdaDeptObj = $HUI.combobox("#BDutybox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        value:rowObj.dutydeptDR,
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 3;
            param.str = param.q;
        },onSelect:function(data){
			$('#BItembox').combobox('clear'); //���ԭ��������
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&deptdr="+data.rowid;
	        $('#BItembox').combobox('reload',Url);//���������б�����
			}
    });
    // Ԥ����ҵ�������
    var UpdaBgDeptObj = $HUI.combobox("#BDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.str = param.q;
        }
    });
    // Ԥ���Ŀ��������
    var UpdaItemObj = $HUI.combobox("#BItembox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.year 	 = $('#BYMbox').combobox('getValue');
            param.deptdr = $('#BDutybox').combobox('getValue');
            param.str 	 = param.q;
        },
        onShowPanel:function(){
        	if($('#BYMbox').combobox('getValue')==""){
        		$(this).combobox('hidePanel');
        		$.messager.popover({
					msg: '����ѡ����ȣ�',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
        		return false;
        	}
        }
    });
    //�ʽ����������
		var UpdaTypeObj=$HUI.combobox("#BFundTypebox",{
			url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
			mode: 'remote',
			delay: 200,
			valueField: 'fundTypeId',
			textField: 'fundTypeNa',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.str = param.q;
			},
			});
    // ����-���µ�������
    var UpdaAEObj = $HUI.combobox("#BAEbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': 1,
                    'name': "����"
                },{
                    'rowid': 2,
                    'name': "����"
        }]
     });
    //Ԥ�㵥�۱仯������Ԥ����
    $('#BPricebox').keyup(function(event){
    	Calcu();
    })
    //Ԥ�������仯������Ԥ����
    $('#BNumbox').numberspinner({
	    value:tmpbudgnum,
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }) 
    //����Ԥ���� = ����*���� 
    function Calcu(){
    	var EditPrice = parseFloat($('#BPricebox').val());  //Ԥ�㵥��
    	if (EditPrice ==""||isNaN(EditPrice)){EditPrice = 0};
    	var EditNum = parseFloat($('#BNumbox').val()); //Ԥ������
    	if (EditNum ==""||isNaN(EditNum)){EditNum = 0};
    	$('#BSumbox').val(EditPrice.toFixed(2)*EditNum.toFixed(0));
    }
    $('#BItembox').combobox('setValue',rowObj.itemcode);
    $('#BPricebox').val(tmpbudgprice);
    $('#BNumbox').val(tmpbudgnum);
    $('#BEquRemarkbox').val(tmpbudgdesc);
    $('#BFeeScabox').val(tmpFeeScale);
    $('#BAnnBenbox').val(tmpAnnBenefit);
    $('#BMatCharbox').val(tmpMatCharge);
    $('#BSupConbox').val(tmpSupCondit);
    $('#BRemarkbox').val(tmpRemarks);
    $('#BBrand1box').val(tmpbrand1);
    $('#BSpec1box').val(tmpspec1);
    $('#BBrand2box').val(tmpbrand2);
    $('#BSpec2box').val(tmpspec2);
    $('#BBrand3box').val(tmpbrand3);
    $('#BSpec3box').val(tmpspec3);
    $('#BAEbox').combobox('setValue',tmpisaddedit);
    $('#BPerOribox').val(tmpPerOrigin);
    $('#BFundTypebox').combobox('setValue',rowObj.fundtypedr);
    $('#BSumbox').val(tmpbudgvalue);
    $('#BPercebox').val(tmpbudgpro);
    $('#BDeptbox').combobox('setValue',rowObj.deptDR);
    //��ӷ��� 
    $("#BtchSave").unbind('click').click(function(){
        var itemcode = $('#BItembox').combobox('getValue');
		var budgprice = $('#BPricebox').val();
		var budgnum = $('#BNumbox').val();
		var budgdesc = $('#BEquRemarkbox').val();  //�豸����
		var FeeScale = $('#BFeeScabox').val();     //�շѱ�׼
		var AnnBenefit = $('#BAnnBenbox').val();   //��Ч��Ԥ��
		var MatCharge = $('#BMatCharbox').val();   //�Ĳķ�
		var SupCondit = $('#BSupConbox').val();    //��������
		var Remarks = $('#BRemarkbox').val();      //˵��
		var brand1 = $('#BBrand1box').val();		  //�Ƽ�Ʒ��1
		var spec1 = $('#BSpec1box').val();		  //����ͺ�1
		var brand2 = $('#BBrand2box').val();		  //�Ƽ�Ʒ��2
		var spec2 = $('#BSpec2box').val();		  //����ͺ�2
		var brand3 = $('#BBrand3box').val();		  //�Ƽ�Ʒ��3
		var spec3 = $('#BSpec3box').val();		  //����ͺ�3
		var isaddedit = $('#BAEbox').combobox('getValue');  //����-����
		var PerOrigin = $('#BPerOribox').val();  //��Ա����-ԭ���豸
		var fundtype = $('#BFundTypebox').combobox('getValue');  //����-���� 
		var budgpro = $('#BPercebox').val();   //��Ԥ��ռ��
		var deptdr = $('#BDeptbox').combobox('getValue');   //Ԥ�����
		
		if(ChkPef()==true){
		var datad = itemcode + '|' + budgprice + '|' + budgnum + '|' + budgdesc
			 + '|' + FeeScale + '|' + AnnBenefit + '|' + MatCharge + '|' + SupCondit + '|' + Remarks + '|'
			+brand1 + '|' + spec1 + '|' + brand2 + '|' + spec2 + '|' + brand3 + '|' + spec3 + '|' + isaddedit + "|" + PerOrigin
			 + "|" + fundtype + '|' + budgpro + '|' + userid + '|' + deptdr + '|' + hospid;
        $.m({
            ClassName:'herp.budg.udata.uBudgProjEstablishDetailToPrj',MethodName:'Update',rowid:rowid,data:datad},
            function(Data){
                if(Data==0){
                    $.messager.popover({
					msg: "����ɹ���",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }
            }
        );
         $win.window('close');
		}
    });

    $("#BtchClose").unbind('click').click(function(){
        $win.window('close');
    });
	}
	
	//����޸İ�ť
	$("#UpdataBn").click(UpdaBtn);
	//��麯��:ɾ�����ύ������
    function ChkBef(info) {
        //�Ƿ�ѡ�м�¼
        var message = "";
        var rows = $('#MainGrid').datagrid('getSelections');
        var len=rows.length; 
        if (len < 1) {
            if(info=="del"){
                message="��ѡ����Ҫɾ��������!";
            }
            if(info=="submit"){
                message="��ѡ����Ҫ�ύ������!";
            }
            if(info=="sum"){
                message="��ѡ����Ҫ���ܵ���Ŀ��ϸ����!";
            }
            $.messager.popover({
					msg: message,
					type: 'info',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
            return false;
        }
        //����״̬�Ƿ���������
        var flag = 1;
        var rowID = "",dutyDept="";
        for (var i = 0; i < len; i++) {
            if ((rows[i].State == "�½�"&&(info=="del"||info=="submit"))||(rows[i].State == "�ύ"&&info=="sum"))
                continue;
            rowID = rows[i].rowid;
            //1����ϸ�������½�״̬��ɾ��
            //2����ϸ�����Ƿ��½�״̬��������Ŀ���½�״̬��ӵ�л���Ȩ�޵��˿�ɾ����
            if (rows[i].projState != "�½�"&&info=="del") {
                flag = -1;
                message = '��ʾ��rowID=' + rowID + '��������Ŀ��"�½�"״̬����ֹɾ����';
                break;
            }
            if (rows[i].isaudit != "1"&&info=="del") {
                flag = -2;
                message = '��ʾ��rowID=' + rowID + '���޻���Ȩ�ޣ���ֹɾ����';
                break;
            }
            if (rows[i].State != "�½�"&&info=="submit") {
                flag = -3;
                message = '��ʾ��rowID=' + rowID + '�����ύ,�����ٴ��ύ��';
                break;
            }
            if (rows[i].State != "�ύ"&&info=="sum") {
                flag = -4;
                message = '��ʾ��rowID=' + rowID + '��ֻ�������"�ύ"״̬�ĵ��ݣ�';
                break;
            }
            if (i == 0) {
                dutyDept = rows[i].dutydeptName;
            }
            if (dutyDept != rows[i].dutydeptName&&info=="sum") {
                flag = -5;
                message = '��ʾ��rowID=' + rowID + '�������ͬһ���ο��ҵ���ϸ�';
                break;
            }
        }
        if (flag != 1) {
            $.messager.popover({
					msg: message,
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
            return false;
        }
        return true;
    }  	
	//ɾ��
	var DelBtn=function(){
	if(ChkBef("del")==true){
		$.messager.confirm('ȷ��','ȷ��Ҫɾ��ѡ����������',function(t){
           if(t){
            var rows = $('#MainGrid').datagrid('getSelections');
            var len = rows.length;
            var data = "";
            for (var i = 0; i < len; i++) {
                if (data == "") {
                    data = rows[i].rowid;
                } else {
                    data = data + "^" + rows[i].rowid;
                }
            }
            $.m({
                ClassName:'herp.budg.udata.uBudgProjEstablishDetailToPrj',MethodName:'Delete',CompDR:hospid,userdr:userid,rowids:data},
                function(Data){
                    if(Data==0){
	                $.messager.popover({
					msg: 'ɾ���ɹ���',
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
					
				});
          $('#MainGrid').datagrid("reload")
                    }else{
	                     $.messager.popover({
					msg: 'ɾ��ʧ��! ������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
          $('#MainGrid').datagrid("reload")
              
                    }
                }
            );
           } 
        })  
	}else{
		return;
	}
	}
	
	//���ɾ����ť
	$("#DelBn").click(DelBtn);
	//�ύ
	var SaveBtn=function(){
	if(ChkBef("submit")==true){
		$.messager.confirm('ȷ��','ȷ��Ҫ�ύ��',function(t){
           if(t){
            var rows = $('#MainGrid').datagrid('getSelections');
            var len = rows.length;
            var data = "";
            for (var i = 0; i < len; i++) {
                if ((rows[i].State == "�½�")
                     || (rows[i].State == '')) {
                    if (data == "") {
                        data = rows[i].rowid;
                    } else {
                        data = data + "^" + rows[i].rowid;
                    }
                }
            }
            $.m({
                ClassName:'herp.budg.udata.uBudgProjEstablishDetailToPrj',MethodName:'Submit',rowids:data},
                function(Data){
                    if(Data==0){
	                $.messager.popover({
					msg: '�ύ�ɹ���',
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
					
				});
          $('#MainGrid').datagrid("reload")
                    }else{
	                     $.messager.popover({
					msg: '�ύʧ�ܣ�������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
          $('#MainGrid').datagrid("reload")
              
                    }
                }
            );
           } 
        })  
	}else{
	return;	
	}	
	}
	//����ύ��ť
	$("#SaveBn").click(SaveBtn);
	//����
	var CollectBtn=function(){
	$("#Detailff").form('clear');
	var rows = $('#MainGrid').datagrid('getSelected');
	if(ChkBef("sum")==true){
		var $win; 
		$win = $('#Collect').window({
				title: '��Ŀ��ϸ��Ϣ����',
				width: 700,
				height: 470,
				top: ($(window).height() - 500) * 0.5,
				left: ($(window).width() - 900) * 0.5,
				shadow: true,
				modal: true,
				iconCls: 'icon-open-book',
				closed: true,
				minimizable: false,
				maximizable: false,
				collapsible: false,
				resizable: true,
				onClose: function () { //�رչرմ��ں󴥷�
					$("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
				}
			});
		$win.window('open');
		
		//��Ŀ����������
		var ProjNameObj = $HUI.combobox("#Namebox", 
		{
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=projName",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			value:rows.itemname,
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.year=$("#PYMbox").combobox('getValue');
				param.str = param.q;
			},onSelect:function(data){
				$('#PYbox').val(makePy(data.name.trim()));
			},
			onShowPanel:function(){
        	if($('#PYMbox').combobox('getValue')==""){
        		$(this).combobox('hidePanel');
        		$.messager.popover({
					msg: '����ѡ����ȣ�',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
        		return false;
        	}
        },
		});
		//ƴ����
         $('#PYbox').val(makePy($('#Namebox').combobox('getValue').trim()));
		//���������
	var YMboxObj = $HUI.combobox("#PYMbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			value:new Date().getFullYear(),
			onBeforeLoad: function (param) {
				param.str = param.q;
			},
			onSelect:function(data){
	        $('#Namebox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=projName&hospid="+hospid+"&userdr="+userid+"&year="+data.year;
	        $('#Namebox').combobox('reload',url);//���������б�����
           }
		});
		// ���Ʒ�ʽ
    var PreTypObj = $HUI.combobox("#PreTypbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': '1',
                    'name': "���϶���"
                },{
                    'rowid': '2',
                    'name': "���¶���"
        }]
     });
     // ������㷽ʽ
    var PreTypObj = $HUI.combobox("#Blancetypebox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': '1',
                    'name': "����Ԥ�����"
                },{
                    'rowid': '2',
                    'name': "����ϸ�����"
        }]
     });
     // ���ο��ҵ�������
	var DutyDRObj = $HUI.combobox("#Deptdrbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			value:rows.dutydeptDR,
			disabled:true,
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 3;
				param.str = param.q;
			},
		});
		//Ԥ�����������
		var DeptDRObj = $HUI.combobox("#Budgdeptdrbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			value:rows.deptDR,
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 2;
				param.str = param.q;
			},
			
		});
		// ������
    var PreTypObj = $HUI.combobox("#Userbox",{ 
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        disabled:true,
        value: userid,
        onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 1;
				param.str = param.q;
			},
     });
     // ��Ŀ����
    var PreTypObj = $HUI.combobox("#TyCmbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': '1',
                    'name': "һ����Ŀ"
                },{
                    'rowid': '2',
                    'name': "������Ŀ"
        },{
                    'rowid': '3',
                    'name': "������Ŀ"
                }]
     });
     // �����ɹ�
    var PreTypObj = $HUI.combobox("#PovBuyDsbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': '1',
                    'name': "��"
                },{
                    'rowid': '2',
                    'name': "��"
        }]
     });
     // ��Ŀ״̬
    var PreTypObj = $HUI.combobox("#ProjStateDs",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        disabled:true,
        data: [{
                    'rowid': '1',
                    'name': "�½�"
                },{
                    'rowid': '2',
                    'name': "ִ��"
                },{
                    'rowid': '3',
                    'name': "���"
        },{
                    'rowid': '4',
                    'name': "ȡ��"
                }]
     });
     //��Ŀ˵��
     $('#DescTxt').val(rows.itemname);
     //�ƻ���ʼʱ��
    
     //��ӷ��� 
    $("#CollectSave").unbind('click').click(function(){
	
	var rowid=rows.rowid;
    var code =$('#Codebox').val();
	var name =$('#Namebox').combobox('getValue');
	var Pinyin = $('#PYbox').val();
	var year = $('#PYMbox').combobox('getValue');
	var pretype = $('#PreTypbox').combobox('getValue'); //���Ʒ�ʽ
	var budgvalue =$('#Budgbox').val(); //��Ŀ��Ԥ��
	var blancetype =$('#Blancetypebox').combobox('getValue'); //������㷽ʽ
	var budgdeptdr =$('#Budgdeptdrbox').combobox('getValue'); //Ԥ�����
	var deptdr =$('#Deptdrbox').combobox('getValue'); //���ο���
	var userdr =userid;//ֱ��Ĭ�ϵ�ǰ��¼��id
	var goal =$('#DescTxt').val();
	var property =$('#TyCmbox').combobox('getValue');
	var isgovbuy =$('#PovBuyDsbox').combobox('getValue');
	var state =$('#ProjStateDs').combobox('getValue');
    var plansdate =$('#PSDateFied').datebox('getValue');
	var planedate =$('#PEDateFied').datebox('getValue');
	var realsdate =$('#RSDateFied').datebox('getValue');
	var realedate =$('#REDateFied').datebox('getValue');
	if (name == "") {
					$.messager.popover({
					msg: '����д��Ŀ����',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
								return;
							}
							if (plansdate == "") {
								$.messager.popover({
					msg: '����д�ƻ���ʼʱ��',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
								return;
							}
							if (planedate == "") {
								$.messager.popover({
					msg: '����д�ƻ�����ʱ��',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
								return;
							}
							if ((plansdate > planedate) || (realsdate > realedate)) {
								$.messager.popover({
					msg: '��ʼʱ�䲻�����ڽ���ʱ��',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
								return;
							}
		    var row = $('#MainGrid').datagrid('getSelections');
            var len = row.length;
            var datas = "";
            for (var i = 0; i < len; i++) {
                    if (datas == "") {
                        datas = row[i].rowid;
                    } else {
                        datas = datas + "^" + row[i].rowid;
                    }
            }
	var data = code + "^" + name + "^" + year + "^" + budgdeptdr + "^" + deptdr + "^" + userdr + "^" + goal + "^" + property + "^" + isgovbuy + "^" + state + "^" + plansdate + "^" + planedate + "^" + realsdate + "^" + realedate + "^" + userid + "^" + hospid + "^" + budgvalue + "^" + pretype + "^" + blancetype + "^" + hospid + "^" + Pinyin;
	$.m({
            ClassName:'herp.budg.udata.uBudgProjEstablishDetailToPrj',MethodName:'SumToPRJ',rowids:datas,data:data},
            function(Data){
                if(Data==0){
                    $.messager.popover({
					msg: "������Ϣ���ɣ�",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
          
                }
            }
        );
        $win.window('close');
    });

    $("#CollectClose").unbind('click').click(function(){
        $win.window('close');
    });
	
	}else{
		return;
	}		
	}
	//������ܰ�ť
	$("#CollectBn").click(CollectBtn);
}