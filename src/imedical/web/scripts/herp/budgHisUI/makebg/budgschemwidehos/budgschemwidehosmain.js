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
        onSelect:function(data){  
        	MainGridObj.load({
            	ClassName:"herp.budg.hisui.udata.uBudgSchemWideHos",
            	MethodName:"ListMain",
            	hospid :    hospid, 
            	UserID :    userid,
            	Year   :    data.year
        	})
     	}
    });
    MainColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:100,hidden: true},
                {field:'bsmyear',title:'年度',width:60},
                {field:'bsmcode',title:'方案编号',width:60},
                {field:'bsmname',title:'方案名称',width:180},
                {field:'bsmorderby',title:'编制顺序',width:60},
                {field:'bidname',title:'结果对应预算项',width:100},
                {field:'bmsuupschemdr',title:'前置方案',width:80,
                    formatter:function(value,row,index){
                        return '<span class="grid-td-text">查询</span>';
                    }
                },
                {field:'bsachkstate',title:'编制状态',width:80,
	                formatter:function(value,row,index){
	                    if (value == 1) {
	                        return '<span class="grid-td-text">新建</span>';
	                    } else if(value == 2) {
	                        return '<span class="grid-td-text">提交</span>';
	                    }else if(value == 3) {
	                        return '<span class="grid-td-text">通过</span>';
	                    }else{
	                        return '<span class="grid-td-text">完成</span>';
	                    }
	                }
	            },
                {field:'bsachkstep',title:'编制步骤',width:80},
                {field:'bcfmchkflowname',title:'审批流',width:100},
                {field:'bsmfile',title:'说明文件',width:100},
                {field:'basriscurstep',title:'是否为当前审批',width:100,hidden: true,
                    formatter:function(value,row,index){
                        if (value == 1) {
                            return '<span>是</span>';
                        } else{
                            return '<span>否</span>';
                        }
                    }
                },
                {field:'schemAuditDR',title:'方案归口表ID',width:100,hidden: true},
                {field:'CurStepNO',title:'当前审批顺序号',width:100,hidden: true},
                {field:'bsarstepno',title:'本人审批顺序号',width:100,hidden: true},
                {field:'StepNO',title:'本人审批流顺序号',width:200,align:'right',hidden: true}
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        /*queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemWideHos",
            MethodName:"ListMain",
            hospid :    hospid, 
            UserID :    userid,
            Year   :    ""        
        },*/
        fitColumns: true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: false, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickCell:function(index, field, value){
            var rows = $('#MainGrid').datagrid('getRows');
            if(field=='bmsuupschemdr'){
                ChildFun(rows[index].rowid)
            }
            if(field=='bsachkstate'){
                schemastatefun(rows[index].schemAuditDR, userid, rows[index].rowid,"","");
            }
            var iscurstep = rows[index].basriscurstep;
            var StepNO = rows[index].bsarstepno; //审批顺序号
            var CurStepNO = rows[index].CurStepNO;
            var bsachkstep = rows[index].bsachkstep;
            var BillState = rows[index].bsachkstate;
            if (BillState == '2') {
                $('#DBackBn').linkbutton("enable");
                $('#DSaveBn').linkbutton("disable");
                $('#DSubBn').linkbutton("disable");
            }
            /*if ((StepNO >= CurStepNO) && (BillState !== '1') && ((StepNO !== "") && (CurStepNO !== ""))) {
                $('#DBackBn').linkbutton("enable");
                $('#DSaveBn').linkbutton("disable");
                $('#DSubBn').linkbutton("disable");
            }*/
            else if (BillState == '1') {
                $('#DBackBn').linkbutton("disable");
                $('#DSaveBn').linkbutton("enable");
                $('#DSubBn').linkbutton("enable");
            }else{
	            $('#DBackBn').linkbutton("disable");
                $('#DSaveBn').linkbutton("disable");
                $('#DSubBn').linkbutton("disable");
	        }
        },
        onClickRow:function(index,row){
	        selectmainindex=index;
        	$("#detailfm").form("clear");
            $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uBudgSchemWideHos",
                MethodName:"ListDetail",
                hospid :    hospid, 
                islast :    "",
                Code   :    row.bsmcode,
                Year   :    row.bsmyear,
                itemcode:   "" ,
                BITName :   ""  
            });     
        },
        toolbar: '#tb'
    });    
    // 查询函数
    var FindBtn= function()
    {
        var Year = $('#YBox').combobox('getValue');  
        MainGridObj.load({
            ClassName:"herp.budg.hisui.udata.uBudgSchemWideHos",
            MethodName:"ListMain",
            hospid :    hospid, 
            UserID :    userid,
            Year   :    Year
        })
    }

    // 点击查询按钮 
    $("#FindBn").click(FindBtn);

	//提交按钮            
    $("#DSubBn").click( function(){
        if (ChkBefSub() == true) {
            submit()
        } else {
            return;
        }      
    });
    //提交前检查
    function ChkBefSub() {
        var rows=$('#MainGrid').datagrid('getSelections')
        if(rows.length<1){
            $.messager.popover({
						    msg:'请选择方案！',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }
			});
            return false;       
        }
        var flag = 0;
        for (var i = 0; i < rows.length; i++) {
            //1:新建,2:提交,3:通过,4:不通过,5:完成
            if ((rows[i].bsachkstate != 1)&& (rows[i].bsachkstate != '')) {
                $.messager.popover({
						    msg:'只有新建单据需提交！',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }
				});
                flag = 1;
                break;
            }
        }
        if (flag == 1) {
            return false;
        }

        return true;
    }
    //提交方法
    function submit() {
        $.messager.confirm('确定','确定要提交吗？',function(t){
            if(t){
                var schemAuditDRs = "";
                var rows=$('#MainGrid').datagrid('getSelections')
                for(i=0;i<rows.length;i++){
                    if ((rows[i].bsachkstate== 1)|| (rows[i].bsachkstate == '')) {
                        if (schemAuditDRs == "") {
                            schemAuditDRs = rows[i].schemAuditDR;
                        } else {
                            schemAuditDRs = schemAuditDRs + "^" + rows[i].schemAuditDR;
                        }
                    }else{
                        continue
                    }
                }
                $.m({
                    ClassName:'herp.budg.hisui.udata.uBudgSchemWideHos',MethodName:'Submits',schemAuditDRs:schemAuditDRs,UserID:userid},
                        function(Data){
                            if(Data==0){
                                $.messager.popover({
						    		msg:'提交成功！',timeout: 3000,type:'info',showType: 'show',
				            		style:{
					            		"position":"absolute",
					            		"z-index":"9999",
					            		left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            		top:1
					        		}
								});
                                $('#DBackBn').linkbutton("enable");
                                $('#DSaveBn').linkbutton("disable");
                                $('#DSubBn').linkbutton("disable");
                            }else{
                                $.messager.popover({
						    		msg: "错误:"+Data,timeout: 3000,type:'error',showType: 'show',
				            		style:{
					            		"position":"absolute",
					            		"z-index":"9999",
					            		left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            		top:1
					        		}
								});
                            }
                        }
                );
                $('#MainGrid').datagrid("reload");
                $('#MainGrid').datagrid('selectRow', selectmainindex);

            }
        })
    }
    //撤销按钮            
    $("#DBackBn").click( function(){
        if (ChkBefBack() == true) {
            Back()
        } else {
            return;
        }      
    });
    //撤销前检查
    function ChkBefBack() {
        var rows=$('#MainGrid').datagrid('getSelections')
        if(rows.length<1){
            $.messager.popover({
						    msg:'请选择方案！',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }
			});
            return false;       
        }
        var flag = 0;
        for (var i = 0; i < rows.length; i++) {
            //1:新建,2:提交,3:通过,4:不通过,5:完成
            if ((rows[i].bsachkstate != 2)&& (rows[i].bsachkstate != '')) {
                $.messager.popover({
						    msg:'只有提交单据可撤销！',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }
				});
                flag = 1;
                break;           
            }
            if (rows[i].bsarstepno == "") {
                //表示这个人没有审核权限
                $.messager.popover({
						    msg:'已审核，不可撤销！',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }
				});
                flag = 1;
                break;
            }
        }
        if (flag == 1) {
            return false;
        }
        return true;
    }
    //撤销方法
    function Back() {
        $.messager.confirm('确定','确定要撤销吗？',function(t){
            if(t){
                var SchemAuditDRs = "";
                var rows=$('#MainGrid').datagrid('getSelections')
                for(i=0;i<rows.length;i++){
                    if ((rows[i].bsarstepno <= rows[i].CurStepNO)&& ((rows[i].bsachkstate == '')||(rows[i].bsachkstate =='2'))) {
                        if (SchemAuditDRs == "") {
                            SchemAuditDRs = rows[i].schemAuditDR;
                        } else {
                            SchemAuditDRs = SchemAuditDRs + "^" + rows[i].schemAuditDR;
                        }
                    }else{
                        continue
                    }
                }
                $.m({
                    ClassName:'herp.budg.hisui.udata.uBudgSchemWideHos',MethodName:'backouts',SchemAuditDRs:SchemAuditDRs,userid:userid},
                        function(Data){
                            if(Data==0){
                                $.messager.popover({
						    		msg:'撤销成功！',timeout: 3000,type:'info',showType: 'show',
				            		style:{
					            		"position":"absolute",
					            		"z-index":"9999",
					            		left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            		top:1
					        		}
								});
                                $('#DBackBn').linkbutton("disable");
                                $('#DSaveBn').linkbutton("enable");
                                $('#DSubBn').linkbutton("enable");
                            }else{
                                $.messager.popover({
						    		msg:"错误:"+Data,timeout: 3000,type:'info',showType: 'show',
				            		style:{
					            		"position":"absolute",
					            		"z-index":"9999",
					            		left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            		top:1
					        		}
								});
                            }
                        }
                );
                $('#MainGrid').datagrid("reload");
                $('#MainGrid').datagrid('selectRow', selectmainindex);

            }
        })
    }
    
}