 
var AccountFlag=0;
var mestring='您确定要将所选入库单入账？';
var buttonstring='入账审核';
var SelectString='全/反选'	
var SelectIcon = 'icon-ok'
var SelectFlag=0
var SelectedRowID = "";
var PreSelectedRowID = "";
var InitItemGridFlag=0;

var curUserID ="" //Add By QW20181101 需求号:735348
//需求序号:	442377		Mozy	20170903
var QUERY_URL = {
	QUERY_GRID_URL : "./dhceq.jquery.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhceq.jquery.combo.easyui.csp"
};

var GlobalObj = {
	UseLocDR : "",
	ProviderDR : "",
	ClearData : function(vElementID)
	{

		if (vElementID=="UseLoc") {this.UseLocDR = "";}

		if (vElementID=="Provider") {this.ProviderDR = "";}

	},
	ClearAll : function()
	{

		this.UseLocDR = "";

		this.ProviderDR = "";

	}
}
//modify by QW0009 修改checkbox兼容性不可选问题(attr->prop)及checkbox选中改变背景色问题
$(document).ready(function () {
	//modify by QW0008 初始化供应商
	initProviderPanel();			//供应商
	initProviderData();			//供应商
	initUseLocPanel();			//科室
	initUseLocData();			//科室
	//end 
	//add by QW0008 总计文本框设置为只读
	setJQValue($("#TotalFee"),"")
	setJQValue($("#TotalNum"),"")
	$("#TotalFee").textbox('textbox').prop('disabled',true); 
	$("#TotalNum").textbox('textbox').prop('disabled',true); 
	//end
	initUserInfo(); //Add By QW20181101 需求号:735348
	$('#DHCEQInStockAccount').datagrid({   
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQAccountList",
	        QueryName:"GetInStock",
	        //modify by QW0008 修改query参数取值方方法
	        Arg1:getJQValue($("#InStockNo")),  
	        Arg2:GlobalObj.ProviderDR,
	        Arg3:getJQValue($("#StartDate")),  
	        Arg4:getJQValue($("#EndDate")),  
	        Arg5:AccountFlag,
	        Arg6:session['LOGON.GROUPID'],
	        Arg7:GlobalObj.UseLocDR,
	        Arg8:getJQValue($("#EquipName")),
	        ArgCnt:8
	    },
	    border:'true',
	    striped:'true', 
	    toolbar:[{   //modify by QW0008 增加全选按钮及全选方法   
	                iconCls: SelectIcon, 
	                text:SelectString,      
	                handler: function(){
	                       selectall();
	                     }      
	                 },'------------------------',{        
	                iconCls: 'icon-cut', 
	                text:buttonstring,      
	                 handler: function(){
	                     DeleteGridData();
	                     }      
	                 },'------------------------',{        
	                iconCls: 'icon-search', 
	                text:'查询',      
	                 handler: function(){
	                     findGridData();
	                     }      
	                 }] , 
   		//modify by QW0008 修改query输出;自定义grid中的checkbox
   		//modify by QW0009 禁止checkbox单选
	    columns:[[
	    	{ field:'TRowID',formatter: function(value,row,index){
				return row.TEnableFlag == "Y" ? '<input type="hidden" />'
		            :'<input type="checkbox" disabled="disabled" name="ckId" value="'+value+'" />';
				}},
	    	{field:'TInStockNo',title:'入库单号',width:150,align:'center'},   // modified by kdf 2018-02-08 需求号：548506  
	        {field:'TBuyLoc',title:'科室',width:100,align:'center'},        
	        {field:'TISLRowID',title:'入库明细ID',width:50,hidden:true},
	        {field:'TQuantityNum',title:'数量',width:150,align:'center'},  
			{field:'TOriginalFee',title:'单价',width:150,align:'center'},
			{field:'TotalFee',title:'总金额',width:100,align:'center'}, 
			{field:'TEquipName',title:'设备名称',width:150,align:'center'},    // modified by jyp 2019-03-11   modified by wy 2019-3-14设备项名称改为设备名称
			{field:'TFunds',title:'资金来源',width:150,align:'center'},
			{field:'TExpenditures',title:'经费来源',width:150,align:'center'},
			{field:'TRemark',title:'备注',width:100,align:'center'}, 
			{field:'TProvider',title:'供应商',width:100,align:'center'}, 
			{field:'TEnableFlag',title:'TEnableFlag',width:50,hidden:true},               
	    ]],
	    //modify by QW0008 增加选中控制
	    onClickRow:function(rowIndex,rowData){
	   
		    if(rowData.TEnableFlag != "Y")
			{
			   if($("input[value='"+rowData.TRowID+"']").prop("checked"))
			   {
			   	 $("input[value='"+rowData.TRowID+"']").prop("checked",false);
			   	
			   }
			   else 
			   {	
				 $("input[value='"+rowData.TRowID+"']").prop("checked",true);
				 
			   }
			}
			Total_Change();
	  },
	    fit: true, 
	    singleSelect: false,
	    pagination:true,
	    pageSize:12,
	    pageNumber:1,
	    pageList:[12,24,36]   
	});

    /*****
	*Add By QW20170602
	*查询方法
	*modify by QW0008 修改query参数取值方方法
	*modify by QW0008 增加全选/反选按钮
	******/   
	function findGridData(){
		$('#DHCEQInStockAccount').datagrid({    
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQAccountList",
	        QueryName:"GetInStock",
	        //modify by QW0008 修改query参数取值方方法
	        Arg1:getJQValue($("#InStockNo")),  
	        Arg2:GlobalObj.ProviderDR,
	        Arg3:getJQValue($("#StartDate")),  
	        Arg4:getJQValue($("#EndDate")),  
	        Arg5:AccountFlag,
	        Arg6:session['LOGON.GROUPID'],
	        Arg7:GlobalObj.UseLocDR,
	        Arg8:getJQValue($("#EquipName")),
	        ArgCnt:8
	    },
	    border:'true',
	    striped:'true',
	    fit: true,
	    toolbar:[{        
	                iconCls: SelectIcon, 
	                text:SelectString,      
	                handler: function(){
	                       selectall();
	                     }      
	                 },'------------------------',{        
	                iconCls: 'icon-cut', 
	                text:buttonstring,      
	                 handler: function(){
	                     DeleteGridData();
	                     }      
	                 },'------------------------',{        
	                iconCls: 'icon-search', 
	                text:'查询',      
	                 handler: function(){
	                     findGridData();
	                     }      
	                 }] 
	   });
	    $("#TotalNum").textbox("setValue","");   //add by wy 2018-2-2
		$("#TotalFee").textbox("setValue","");
	   
	}

	/*****
	*Add By QW20170602
	*审核及取消审核
	*根据选中的入库单ID进行审核及取消审核入账
	*modify by QW0008 修改入库单ID获取方式
	*modify by QW0008 增加user参数。
	*modify by QW0008 修改返回值判断。
	******/
	function DeleteGridData(){
		var combindata=$("input[name='ckId']").map(function () { 
		if($(this).prop("checked"))  return $(this).val();         
		}).get().join(",");
	    if (combindata!="") {
	        $.messager.confirm('请确认', mestring, function (b) { 
	        if (b==false)
	        {
	             return;
	        }
	        else
	        {
	       
		        $.ajax({
		            url :"dhceq.jquery.method.csp",
		            type:"POST",
		            data:{
		                ClassName:"web.DHCEQAccountList",
		                MethodName:"SaveDataByStockDR",
		                Arg1:combindata,
		                Arg2:AccountFlag,
		                Arg3:curUserID,    
		                ArgCnt:3
		            },
		            success:function (data, response, status) {
		            $.messager.progress('close');
		            
		            var errorcode=data.split("^"); 
		            if (errorcode[0] ==0) {
			            setJQValue($("#TotalFee"),"")
						setJQValue($("#TotalNum"),"")
			            $('#DHCEQInStockAccount').datagrid('reload');
			            $.messager.show({
			                title: '提示',
			                msg: '操作成功'
			            });
		            }   
		            else {
		               $.messager.alert('操作失败！',errorcode[0], 'warning')
		               return;
		              }
		           }
            
		        })
		        }       
		        })
     
	    }
	    else
	    {
	        $.messager.alert("错误","请选择一行！",'err')
	    }
	}

	/*****
	*Add By QW20170602
	*响应入账标志按钮，重新进行查询
	*buttonstring:按钮文本
	*mestring:操作提示文本
	*Modify By QW20170927 需求号:456193
	******/
	$('#AccountFlag').click(function () {
		setJQValue($("#TotalFee"),"")
		setJQValue($("#TotalNum"),"")
		SelectFlag=0
		if(jQuery('#AccountFlag').is(':checked')==true)
		{
			mestring='您确定要将所选入库单取消入账？'
			buttonstring='入账取消'
			AccountFlag=1;
		}
		else 
		{ 
			AccountFlag=0;
			mestring='您确定要将所选入库单入账？';
			buttonstring='入账审核';
		
		}
		findGridData();
	});
	/*****
	*Add By QW0008 
	*全选/反选当页所有checkbox
	*modify by QW0009 增加行全选和取消
	******/
	function selectall(){
		
		 $("input[name='ckId']").each(function(rowIndex,rowData) {
			 if(SelectFlag==1)
		     {
			    
			    $(this).prop("checked", false);  
		     } 
	    	 else
	    	 {
		    	$('#DHCEQInStockAccount').datagrid('selectAll');
		    	$(this).prop("checked", true); 
		    	
		 	 }   
	   });  
	    if(SelectFlag==0) 
	    {
		    $('#DHCEQInStockAccount').datagrid('selectAll');
		    SelectFlag=1	
	    }      
	   else 
	   {
		   $('#DHCEQInStockAccount').datagrid('unselectAll');
		   SelectFlag=0
	   }
	   Total_Change();
	}
	/*****
	*Add By QW0008 
	*根据选中的入单id统计所有数量及金额
	*设置金额总计和数量总计两个文本框的值
	******/
	function Total_Change()
	{
		var combindata=$("input[name='ckId']").map(function () { 
				if($(this).prop("checked"))  return $(this).val();         
			}).get().join(",");
        $.ajax({
	        url :"dhceq.jquery.method.csp",
	        type:"POST",
	        data:{
	            ClassName:"web.DHCEQAccountList",
	            MethodName:"CalculaTotal",
	            Arg1:combindata,
	            ArgCnt:1
	        },
	        success:function (data, response, status) {
	        $.messager.progress('close');
	        var result=data.split("^"); 
	       $("#TotalNum").textbox("setValue",result[0]);
		   $("#TotalFee").textbox("setValue",result[1]);

       }

    })
	}
	
	

});
//需求序号:	442377		Mozy	20170903
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="UseLoc") {GlobalObj.UseLocDR = CurValue;}

	if (vElementID=="Provider") {GlobalObj.ProviderDR = CurValue;}
}

function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");

	if (vElementID=="UseLoc") {initUseLocData();}

	if (vElementID=="Provider") {initProviderData();}
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function initProviderData()
{
	var vParams=jQuery("#Provider").combogrid("getText")
	initComboData("Provider","web.DHCEQ.Process.DHCEQFind","GetVendor",vParams,1)
}
function initUseLocData()
{
	var vParams=","+jQuery("#UseLoc").combogrid("getText")+",,0102,"
	initComboData("UseLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}

function initUseLocPanel()
{
	initComboGrid("UseLoc","科室名称",400,true);
}

function initProviderPanel()
{
	initComboGrid("Provider","供应商",400,true);
}

//Add By QW20181101 需求号:735348
function initUserInfo()
{
	 //modify by lmm 2018-10-24 重定义系统会话变量：以curSS做前缀
	var curSSUserID=session['LOGON.USERID']; 
	var curSSLocID=session['LOGON.CTLOCID'];      
    var curSSHospitalID=session['LOGON.GROUPID'];
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetMapIDBySource",curSSUserID,curSSLocID,curSSHospitalID);
    jsonData=jQuery.parseJSON(jsonData);
    curUserID=jsonData.Data["MapUserID"];
}