var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
$(function () { //初始化
	Init();
});

function Init() {
	//年度下拉框
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
	        $('#Itemnamebox').combobox('clear'); //清除原来的数据
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&year="+data.year;
	        $('#Itemnamebox').combobox('reload',Url);//联动下拉列表重载
	        $('#ProjNamebox').combobox('clear'); //清除原来的数据
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=projName&hospid="+hospid+"&userdr="+userid+"&year="+data.year;
	        $('#ProjNamebox').combobox('reload',url);//联动下拉列表重载
	        //console.log(JSON.stringify(data));
	        var Year = $('#YMbox').combobox('getValue'); // 申请年度
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // 责任科室
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // 预算科目
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // 项目名称
		    var FundType = $('#FundTypebox').combobox('getValue'); // 资金类别
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // 预算科室
		    var State = $('#Statebox').combobox('getValue'); // 状态
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
	// 责任科室的下拉框
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
			$('#Itemnamebox').combobox('clear'); //清除原来的数据
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&deptdr="+data.rowid;
	        $('#Itemnamebox').combobox('reload',Url);//联动下拉列表重载
	        var Year = $('#YMbox').combobox('getValue'); // 申请年度
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // 责任科室
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // 预算科目
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // 项目名称
		    var FundType = $('#FundTypebox').combobox('getValue'); // 资金类别
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // 预算科室
		    var State = $('#Statebox').combobox('getValue'); // 状态
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
		//资金类别下拉框
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
			var Year = $('#YMbox').combobox('getValue'); // 申请年度
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // 责任科室
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // 预算科目
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // 项目名称
		    var FundType = $('#FundTypebox').combobox('getValue'); // 资金类别
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // 预算科室
		    var State = $('#Statebox').combobox('getValue'); // 状态
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
		//状态
		var StateObj = $HUI.combobox("#Statebox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        onSelect:function(data){
			var Year = $('#YMbox').combobox('getValue'); // 申请年度
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // 责任科室
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // 预算科目
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // 项目名称
		    var FundType = $('#FundTypebox').combobox('getValue'); // 资金类别
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // 预算科室
		    var State = $('#Statebox').combobox('getValue'); // 状态
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
                    'name': "新建"
                },{
                    'rowid': "1",
                    'name': "提交"
               },{
	               'rowid': "2",
                    'name': "已汇总"
               },{
                    'rowid': "3",
                    'name': "合同已审核"
               }]
        });
		
		//预算科室下拉框
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
			var Year = $('#YMbox').combobox('getValue'); // 申请年度
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // 责任科室
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // 预算科目
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // 项目名称
		    var FundType = $('#FundTypebox').combobox('getValue'); // 资金类别
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // 预算科室
		    var State = $('#Statebox').combobox('getValue'); // 状态
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
		
		//预算科目下拉框
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
			var Year = $('#YMbox').combobox('getValue'); // 申请年度
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // 责任科室
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // 预算科目
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // 项目名称
		    var FundType = $('#FundTypebox').combobox('getValue'); // 资金类别
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // 预算科室
		    var State = $('#Statebox').combobox('getValue'); // 状态
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
					msg: '请先选择年度！',
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
		
		//项目名称下拉框
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
			var Year = $('#YMbox').combobox('getValue'); // 申请年度
		    var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // 责任科室
		    var Itemname = $('#Itemnamebox').combobox('getValue'); // 预算科目
		    var ProjName = $('#ProjNamebox').combobox('getValue'); // 项目名称
		    var FundType = $('#FundTypebox').combobox('getValue'); // 资金类别
		    var DeptDR = $('#DeptDRbox').combobox('getValue'); // 预算科室
		    var State = $('#Statebox').combobox('getValue'); // 状态
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
					msg: '请先选择年度！',
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
                {field:'ck',checkbox:true},//复选框
                {field:'rowid',title:'明细ID',width:80,hidden: true},
                {field:'projadjdr',title:'主表ID',width:80,hidden: true},
                {field:'fundtypedr',title:'资金类别ID',width:80,hidden: true},
                {field:'fundtype',title:'资金类别',width:120},
                {field:'projName',title:'项目名称',width:220},
                {field:'itemcode',title:'科目编码',width:80,hidden: true},
                {field:'bidlevel',title:'预算级别',width:80,hidden: true},
                {field:'itemname',title:'科目名称',width:220},
                {field:'deptDR',title:'预算科室',width:80,hidden: true},
                {field:'deptName',title:'预算科室',width:120},
                {field:'bidislast',title:'是否末级',width:80,hidden: true},
                {field:'budgprice',title:'预算单价',align:'left',width:180,
		    	    formatter:function(value,row,index){
		                 if(value>0){
		                 	return '<span>' + (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,') + '</span>';
		                 }
		            }
		    	},
                {field:'budgnum',title:'预算数量',align:'left',width:100},
                {field:'budgpro',title:'总预算占比(%)',align:'left',width:120},
                {field:'budgvalue',title:'预算金额',align:'left',width:180,
		    	    formatter:function(value,row,index){
		                 if(value>0){
		                 	return '<span>' + (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,') + '</span>';
		                 }
		            }
		    	},
                {field:'isaddedit',title:'新增/更新',width:80},
                {field:'dutydeptDR',title:'责任科室ID',width:100,hidden: true},
                {field:'dutydeptName',title:'责任科室',width:120},
                {field:'State',title:'状态',width:60},
                {field:'SSUSRName',title:'申请人',width:80,hidden: true},
                {field:'isaudit',title:'有否汇总权限',width:150,hidden: true},
                {field:'projState',title:'项目状态',width:120,hidden: true},
                {field:'budgdesc',title:'设备名称备注',width:120},
                {field:'PerOrigin',title:'人员资质-原有设备',width:150},
                {field:'FeeScale',title:'收费标准',width:120},
                {field:'AnnBenefit',title:'年效益预测',width:120},
                {field:'MatCharge',title:'耗材费',width:80},
                {field:'SupCondit',title:'配套条件',width:120},
                {field:'Remarks',title:'备注',width:120},
                {field:'brand1',title:'推荐品牌1',width:120},
                {field:'spec1',title:'规格型号1',width:120},
                {field:'brand2',title:'推荐品牌2',width:120},
                {field:'spec2',title:'规格型号2',width:120},
                {field:'brand3',title:'推荐品牌3',width:120},
                {field:'spec3',title:'规格型号3',width:120}
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
			fitColumns: false, //列固定
			loadMsg: "正在加载，请稍等…",
			autoRowHeight: true,
			rownumbers: true, //行号
			ctrlSelec: true, //在启用多行选择的时候允许使用Ctrl键+鼠标点击的方式进行多选操作
			// singleSelect: true, //只允许选中一行
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100], //页面大小选择列表
			pagination: true, //分页
			fit: true,
			columns: MainColumns,
			rowStyler: function (index, row) {
				if (row.State == "提交") {
					return 'background-color:#F0FFFF;';
				}if (row.State == "已汇总") {
					return 'background-color:#FFF0F5;';
				}
			},
			toolbar: '#tb'
		});
		
		 
			//JSON.stringify(rows)
	//查询函数
	var FindBtn = function () {
		var Year = $('#YMbox').combobox('getValue'); // 申请年度
		var DutydeptName = $('#DutydeptNamebox').combobox('getValue'); // 责任科室
		var Itemname = $('#Itemnamebox').combobox('getValue'); // 预算科目
		var ProjName = $('#ProjNamebox').combobox('getValue'); // 项目名称
		var FundType = $('#FundTypebox').combobox('getValue'); // 资金类别
		var DeptDR = $('#DeptDRbox').combobox('getValue'); // 预算科室
		var State = $('#Statebox').combobox('getValue'); // 状态
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
	
	//点击查询按钮
	$("#FindBn").click(FindBtn);
	function ChkPef(){
	if(($('#BDutybox').combobox('getValue')=="")||($('#BDeptbox').combobox('getValue')=="")||($('#BItembox').combobox('getValue')=="")||($('#BAEbox').combobox('getValue')=="")||($('#BNumbox').val()=="")||($('#BPricebox').val()=="")){
		$.messager.popover({
					msg: '必选项不能为空！',
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
	//新增
	var AddBtn=function(){	
		var $win; 
		$("#Detailff").form('clear');
		$win = $('#Add').window({
				title: '添加项目明细信息',
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
				onClose: function () { //关闭关闭窗口后触发
					$("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
				}
			});
		$win.window('open');
		// 年度的下拉框
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
	        $('#BItembox').combobox('clear'); //清除原来的数据
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&year="+data.year;
	        $('#BItembox').combobox('reload',Url);//联动下拉列表重载
        }
    });
    // 责任科室的下拉框
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
			$('#BItembox').combobox('clear'); //清除原来的数据
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&deptdr="+data.rowid;
	        $('#BItembox').combobox('reload',Url);//联动下拉列表重载
			}
    });
    // 预算科室的下拉框
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
    // 预算科目的下拉框
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
					msg: '请先选择年度！',
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
    // 资金类型的下拉框
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
    // 新增-更新的下拉框
    var AddAEObj = $HUI.combobox("#BAEbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': 1,
                    'name': "新增"
                },{
                    'rowid': 2,
                    'name': "更新"
        }]
     });
    //预算单价变化，计算预算金额
    $('#BPricebox').keyup(function(event){
    	Calcu();
    })
    //预算数量变化，计算预算金额
    $('#BNumbox').numberspinner({
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }) 
    //计算预算金额 = 单价*数量 
    function Calcu(){
    	var AddPrice = parseFloat($('#BPricebox').val());  //预算单价
    	if (AddPrice ==""||isNaN(AddPrice)){AddPrice = 0};
    	var AddNum = parseFloat($('#BNumbox').val()); //预算数量
    	if (AddNum ==""||isNaN(AddNum)){AddNum = 0};
    	$('#BSumbox').val(AddPrice.toFixed(2)*AddNum.toFixed(0));
    }
    //添加方法 
    $("#BtchSave").unbind('click').click(function(){
	    var dutydeptdr=$('#BDutybox').combobox('getValue');
        var itemcode = $('#BItembox').combobox('getValue');//预算科目
		var budgprice = $('#BPricebox').val();
		var budgnum = $('#BNumbox').val();
		var budgdesc = $('#BEquRemarkbox').val();  //设备名称
		var FeeScale = $('#BFeeScabox').val();     //收费标准
		var AnnBenefit = $('#BAnnBenbox').val();   //年效益预测
		var MatCharge = $('#BMatCharbox').val();   //耗材费
		var SupCondit = $('#BSupConbox').val();    //配套条件
		var Remarks = $('#BRemarkbox').val();      //说明
		var brand1 = $('#BBrand1box').val();		  //推荐品牌1
		var spec1 = $('#BSpec1box').val();		  //规格型号1
		var brand2 = $('#BBrand2box').val();		  //推荐品牌2
		var brand3 = $('#BBrand3box').val();		  //推荐品牌3
		var spec3 = $('#BSpec3box').val();		  //规格型号3
		var spec2 = $('#BSpec2box').val();		  //规格型号2
		var isaddedit = $('#BAEbox').combobox('getValue');  //新增-更新
		var PerOrigin = $('#BPerOribox').val();  //人员资质-原有设备
		var fundtype = $('#BFundTypebox').combobox('getValue');  //资金类型 
		var budgpro = $('#BPercebox').val();   //总预算占比
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
					msg: "保存成功！",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '错误信息:' +Data,
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
	//点击新增按钮
	$("#AddBn").click(AddBtn);
	//修改
	var UpdaBtn=function(){
	var rowObj = $('#MainGrid').datagrid('getSelected');
	var rows = $('#MainGrid').datagrid('getSelections');
	if(rows.length!=1){
	$.messager.popover({
					msg: '请选择一条数据修改!',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
				return false;
	}
	if(rowObj.State!="新建"){
		$.messager.popover({
					msg: '无权限修改非“新建”状态单据！',
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
				title: '修改项目明细信息',
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
				onClose: function () { //关闭关闭窗口后触发
					$("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
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
    if (tmpisaddedit == "新增") {
        tmpisaddedit = 1;
    }
    if (tmpisaddedit == "更新") {
        tmpisaddedit = 2;
    }
    var tmpPerOrigin = rowObj.PerOrigin;
    var tmpfundtype = rowObj.fundtypedr;
    var tmpbudgpro = rowObj.budgpro;
    var tmpbudgvalue = rowObj.budgvalue;
    var tmpdeptdr = rowObj.deptDR;
    // 年度的下拉框
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
	        $('#BItembox').combobox('clear'); //清除原来的数据
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&year="+data.year;
	        $('#BItembox').combobox('reload',Url);//联动下拉列表重载
        }
    });
    // 责任科室的下拉框
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
			$('#BItembox').combobox('clear'); //清除原来的数据
	        var Url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName&hospid="+hospid+"&deptdr="+data.rowid;
	        $('#BItembox').combobox('reload',Url);//联动下拉列表重载
			}
    });
    // 预算科室的下拉框
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
    // 预算科目的下拉框
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
					msg: '请先选择年度！',
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
    //资金类别下拉框
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
    // 新增-更新的下拉框
    var UpdaAEObj = $HUI.combobox("#BAEbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': 1,
                    'name': "新增"
                },{
                    'rowid': 2,
                    'name': "更新"
        }]
     });
    //预算单价变化，计算预算金额
    $('#BPricebox').keyup(function(event){
    	Calcu();
    })
    //预算数量变化，计算预算金额
    $('#BNumbox').numberspinner({
	    value:tmpbudgnum,
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }) 
    //计算预算金额 = 单价*数量 
    function Calcu(){
    	var EditPrice = parseFloat($('#BPricebox').val());  //预算单价
    	if (EditPrice ==""||isNaN(EditPrice)){EditPrice = 0};
    	var EditNum = parseFloat($('#BNumbox').val()); //预算数量
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
    //添加方法 
    $("#BtchSave").unbind('click').click(function(){
        var itemcode = $('#BItembox').combobox('getValue');
		var budgprice = $('#BPricebox').val();
		var budgnum = $('#BNumbox').val();
		var budgdesc = $('#BEquRemarkbox').val();  //设备名称
		var FeeScale = $('#BFeeScabox').val();     //收费标准
		var AnnBenefit = $('#BAnnBenbox').val();   //年效益预测
		var MatCharge = $('#BMatCharbox').val();   //耗材费
		var SupCondit = $('#BSupConbox').val();    //配套条件
		var Remarks = $('#BRemarkbox').val();      //说明
		var brand1 = $('#BBrand1box').val();		  //推荐品牌1
		var spec1 = $('#BSpec1box').val();		  //规格型号1
		var brand2 = $('#BBrand2box').val();		  //推荐品牌2
		var spec2 = $('#BSpec2box').val();		  //规格型号2
		var brand3 = $('#BBrand3box').val();		  //推荐品牌3
		var spec3 = $('#BSpec3box').val();		  //规格型号3
		var isaddedit = $('#BAEbox').combobox('getValue');  //新增-更新
		var PerOrigin = $('#BPerOribox').val();  //人员资质-原有设备
		var fundtype = $('#BFundTypebox').combobox('getValue');  //新增-更新 
		var budgpro = $('#BPercebox').val();   //总预算占比
		var deptdr = $('#BDeptbox').combobox('getValue');   //预算科室
		
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
					msg: "保存成功！",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '错误信息:' +Data,
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
	
	//点击修改按钮
	$("#UpdataBn").click(UpdaBtn);
	//检查函数:删除、提交、汇总
    function ChkBef(info) {
        //是否选中记录
        var message = "";
        var rows = $('#MainGrid').datagrid('getSelections');
        var len=rows.length; 
        if (len < 1) {
            if(info=="del"){
                message="请选择需要删除的数据!";
            }
            if(info=="submit"){
                message="请选择需要提交的数据!";
            }
            if(info=="sum"){
                message="请选择需要汇总的项目明细数据!";
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
        //数据状态是否满足条件
        var flag = 1;
        var rowID = "",dutyDept="";
        for (var i = 0; i < len; i++) {
            if ((rows[i].State == "新建"&&(info=="del"||info=="submit"))||(rows[i].State == "提交"&&info=="sum"))
                continue;
            rowID = rows[i].rowid;
            //1，明细单据是新建状态可删除
            //2，明细单据是非新建状态，关联项目是新建状态，拥有汇总权限的人可删除。
            if (rows[i].projState != "新建"&&info=="del") {
                flag = -1;
                message = '提示：rowID=' + rowID + '；关联项目非"新建"状态，禁止删除！';
                break;
            }
            if (rows[i].isaudit != "1"&&info=="del") {
                flag = -2;
                message = '提示：rowID=' + rowID + '；无汇总权限，禁止删除！';
                break;
            }
            if (rows[i].State != "新建"&&info=="submit") {
                flag = -3;
                message = '提示：rowID=' + rowID + '；已提交,不能再次提交！';
                break;
            }
            if (rows[i].State != "提交"&&info=="sum") {
                flag = -4;
                message = '提示：rowID=' + rowID + '；只允许汇总"提交"状态的单据！';
                break;
            }
            if (i == 0) {
                dutyDept = rows[i].dutydeptName;
            }
            if (dutyDept != rows[i].dutydeptName&&info=="sum") {
                flag = -5;
                message = '提示：rowID=' + rowID + '；请汇总同一责任科室的明细项！';
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
	//删除
	var DelBtn=function(){
	if(ChkBef("del")==true){
		$.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
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
					msg: '删除成功！',
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
					
				});
          $('#MainGrid').datagrid("reload")
                    }else{
	                     $.messager.popover({
					msg: '删除失败! 错误信息:' +Data,
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
	
	//点击删除按钮
	$("#DelBn").click(DelBtn);
	//提交
	var SaveBtn=function(){
	if(ChkBef("submit")==true){
		$.messager.confirm('确定','确定要提交吗？',function(t){
           if(t){
            var rows = $('#MainGrid').datagrid('getSelections');
            var len = rows.length;
            var data = "";
            for (var i = 0; i < len; i++) {
                if ((rows[i].State == "新建")
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
					msg: '提交失败！错误信息:' +Data,
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
	//点击提交按钮
	$("#SaveBn").click(SaveBtn);
	//汇总
	var CollectBtn=function(){
	$("#Detailff").form('clear');
	var rows = $('#MainGrid').datagrid('getSelected');
	if(ChkBef("sum")==true){
		var $win; 
		$win = $('#Collect').window({
				title: '项目明细信息汇总',
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
				onClose: function () { //关闭关闭窗口后触发
					$("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
				}
			});
		$win.window('open');
		
		//项目名称下拉框
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
					msg: '请先选择年度！',
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
		//拼音码
         $('#PYbox').val(makePy($('#Namebox').combobox('getValue').trim()));
		//年度下拉框
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
	        $('#Namebox').combobox('clear'); //清除原来的数据
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=projName&hospid="+hospid+"&userdr="+userid+"&year="+data.year;
	        $('#Namebox').combobox('reload',url);//联动下拉列表重载
           }
		});
		// 编制方式
    var PreTypObj = $HUI.combobox("#PreTypbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': '1',
                    'name': "自上而下"
                },{
                    'rowid': '2',
                    'name': "自下而上"
        }]
     });
     // 结余计算方式
    var PreTypObj = $HUI.combobox("#Blancetypebox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': '1',
                    'name': "按总预算计算"
                },{
                    'rowid': '2',
                    'name': "按明细项计算"
        }]
     });
     // 责任科室的下拉框
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
		//预算科室下拉框
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
		// 负责人
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
     // 项目性质
    var PreTypObj = $HUI.combobox("#TyCmbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': '1',
                    'name': "一般项目"
                },{
                    'rowid': '2',
                    'name': "基建项目"
        },{
                    'rowid': '3',
                    'name': "科研项目"
                }]
     });
     // 政府采购
    var PreTypObj = $HUI.combobox("#PovBuyDsbox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': '1',
                    'name': "是"
                },{
                    'rowid': '2',
                    'name': "否"
        }]
     });
     // 项目状态
    var PreTypObj = $HUI.combobox("#ProjStateDs",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        disabled:true,
        data: [{
                    'rowid': '1',
                    'name': "新建"
                },{
                    'rowid': '2',
                    'name': "执行"
                },{
                    'rowid': '3',
                    'name': "完成"
        },{
                    'rowid': '4',
                    'name': "取消"
                }]
     });
     //项目说明
     $('#DescTxt').val(rows.itemname);
     //计划开始时间
    
     //添加方法 
    $("#CollectSave").unbind('click').click(function(){
	
	var rowid=rows.rowid;
    var code =$('#Codebox').val();
	var name =$('#Namebox').combobox('getValue');
	var Pinyin = $('#PYbox').val();
	var year = $('#PYMbox').combobox('getValue');
	var pretype = $('#PreTypbox').combobox('getValue'); //编制方式
	var budgvalue =$('#Budgbox').val(); //项目总预算
	var blancetype =$('#Blancetypebox').combobox('getValue'); //结余计算方式
	var budgdeptdr =$('#Budgdeptdrbox').combobox('getValue'); //预算科室
	var deptdr =$('#Deptdrbox').combobox('getValue'); //责任科室
	var userdr =userid;//直接默认当前登录人id
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
					msg: '请填写项目名称',
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
					msg: '请填写计划开始时间',
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
					msg: '请填写计划结束时间',
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
					msg: '开始时间不能晚于结束时间',
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
					msg: "汇总信息生成！",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '错误信息:' +Data,
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
	//点击汇总按钮
	$("#CollectBn").click(CollectBtn);
}