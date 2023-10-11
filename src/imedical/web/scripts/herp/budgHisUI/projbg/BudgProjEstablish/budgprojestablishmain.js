/**
CSP: herp.budg.hisui.budgschemwidehos.csp
*/

var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
var selectmainindex="";
$(function(){//初始化
    Init();
    Detail();
}); 

function Init(){
    //年度
    var YBoxObj = $HUI.combobox("#YBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        /**onSelect:function(){
            $('#DBox').combobox('clear');
			$('#DBox').combobox('reload');			
        	MainGridObj.load({
            	ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
            	MethodName:"ListMain",
            	hospid :    hospid, 
            	year   :    $("#YBox").combobox('getValue'),
				budgdept:   "",
				state:      "",
				userid:     userid
        	})
     	}**/
    });
	var DBoxObj = $HUI.combobox("#DBox",{
		url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Deptnamelist",
        mode:'remote',
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
	});
	var XBoxObj = $HUI.combobox("#XBox",{
		valueField:"id",
		textField:"text",
		defaultFilter:4,
		data:[{id:'1',text:'新建'},
			  {id:'2',text:'执行'},
			  {id:'4',text:'取消'}],
	});
    MainColumns=[[  
                //{field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'项目ID',width:100,hidden:true},
				{field:'projadjdr',title:'主表ID',width:80,hidden:true},
                {field:'CompName',title:'医疗单位',width:60,hidden:true},
				{field:'code',title:'项目编码',width:140},
				{field:'name',title:'项目名称',width:200},
				{field:'year',title:'年度',width:60},
				{field:'chkstate',title:'项目审批状态',width:90,hidden:true},
				{field:'chkstatelist',title:'审批状态',width:80},
				{field:'fundtotal',title:'总预算',width:120},
				{field:'dataIndex1',title:'政府拨款',width:120},
				{field:'dataIndex2',title:'社会捐助',width:120},
				{field:'dataIndex3',title:'自筹资金',width:120},
				{field:'property',title:'项目性质',width:100,hidden: true},
				{field:'propertylist',title:'项目性质',width:100},
				{field:'isgovbuy',title:'政府采购',width:50,hidden: true},
				{field:'isgovbuylist',title:'政府采购',width:75},
				{field:'deptdr',title:'责任科室',width:100,hidden: true},
				{field:'deptname',title:'责任科室',width:100},
				{field:'bdeptname',title:'预算科室',width:100},
				{field:'dutydr',title:'项目负责人',width:100,hidden: true},
				{field:'username',title:'项目负责人',width:100},
				{field:'state',title:'项目状态',width:100,hidden: true},
				{field:'statelist',title:'项目状态',width:75},
				{field:'filedesc',title:'附件',width:100},
				{field:'changefag',title:'变更标记',width:110,hidden:true},
				{field:'basriscurstep',title:'是否为当前审批',width:110 },
				{field:'CurStepNO',title:'当前审批顺序号',width:110,hidden:true},
				{field:'bsarstepno',title:'本人审批顺序号',width:110,hidden:true },
				{field:'StepNo',title:'本人审批流顺序号',width:150,hidden:true },
				{field:'realedate',title:'实际结束时间',width:120,hidden:true }
        
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
            MethodName:"ListMain",
            hospid :    hospid, 
            year   :    "",
		    budgdept:   "",
			state:      "",
			userid:     userid        
        },
        delay:200,
        fitColumns: false,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
		singleSelect:true,
		striped:true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
		onClickCell:function(index,field,value){
			var rows = $('#MainGrid').datagrid('getRows');
			var BillState = rows[index].chkstate;
			if (BillState =='1'){
				$('#DBackBn').linkbutton("enable");
				$('#DSubBn').linkbutton("disable");
				$('#AddBn').linkbutton("disable");
				$('#UpdataBn').linkbutton("disable");
				$('#DelBn').linkbutton("disable");
			}else if (BillState == '0'){
				$('#DBackBn').linkbutton("disable");
				$('#DSubBn').linkbutton("enable");
				$('#AddBn').linkbutton("enable");
				$('#UpdataBn').linkbutton("enable");
				$('#DelBn').linkbutton("enable");
			}else{
				$('#DBackBn').linkbutton("disable");
				$('#DSubBn').linkbutton("disable");
				$('#AddBn').linkbutton("disable");
				$('#UpdataBn').linkbutton("disable");
				$('#DelBn').linkbutton("disable");
			}
		},
		onClickRow:function(index,row){
	        selectmainindex=index;
        	//$("#detailfm").form("clear");
            $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
                MethodName:"ListDetail",
                hospid :    hospid, 
                projadjdr :  row.projadjdr    
            });     
        },
        toolbar: '#tb'
    }); 
    // 查询函数
    var FindBtn= function()
    {
        //var Year = $('#YBox').combobox('getValue'); 
        //var Budgdept = $('#DBox').combobox('getValue'); 
        //var State = $('#XBox').combobox('getValue'); 		
        MainGridObj.load({
            ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
            MethodName:"ListMain",
            hospid :    hospid, 
            year   :    $('#YBox').combobox('getValue'),
		    budgdept:   $('#DBox').combobox('getValue'),
			state:      $('#XBox').combobox('getValue'),
			userid:     userid 
        })
    };

    // 点击查询按钮 
    $("#FindBn").click(FindBtn);

    // 提交函数
    var SubmitBtn = function()
    {
		//alert('ok');
		$.messager.confirm('确定','确定要提交数据吗？',function(t){
           if(t){
            var rows = $('#MainGrid').datagrid('getSelections');
            var len = rows.length;
			for(var i=0;i<rows.length;i++){
				var rowid=rows[i]['rowid'];
				var fundown=rows[i]['dataIndex3'];
				var fundgov=rows[i]['dataIndex1'];
                $.m({
                ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',
				MethodName:'Submit',
				id:rowid,
				userid:userid,
				fundown:"",
				fundgov:""},
                function(Data){
                    if(Data==0){
	                $.messager.popover({
					msg: '提交成功！',
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
					 
				});
                $('#MainGrid').datagrid("reload")
                    }else{
	                     $.messager.popover({
					msg: '提交失败! 错误信息:' +Data,
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
			}; 
           } 
        })  
	};	
	// 点击提交按钮
	$("#DSubBn").click(SubmitBtn);
	
	// 提交函数
    var DBackBtn = function()
    {
		//alert('ok');
		$.messager.confirm('确定','确定要撤销数据吗？',function(t){
           if(t){
            var rows = $('#MainGrid').datagrid('getSelections');
            var len = rows.length;
			for(var i=0;i<rows.length;i++){
				var rowid=rows[i]['rowid'];
				var projadjdr=rows[i]['projadjdr'];
                $.m({
                ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',
				MethodName:'CancelSubmit',
				rowid:rowid,
				projadjdr:projadjdr,
				userid:userid},
                function(Data){
                    if(Data==0){
	                $.messager.popover({
					msg: '撤销成功！',
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
					 
				});
                $('#MainGrid').datagrid("reload")
                    }else{
	                     $.messager.popover({
					msg: '撤销失败! 错误信息:' +Data,
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
			}; 
           } 
        })  
	};	
	// 点击提交按钮
	$("#DBackBn").click(DBackBtn);
	
}