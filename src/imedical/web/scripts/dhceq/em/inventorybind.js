/**
 * @desc 界面入口函数
 * @author zouxuan 2022-09-22
 */
$(function(){
	$(function(){$("#Loading").fadeOut("fast");});
	initDocument();
});

/**
 * @desc 界面初始化加载
 * @author zouxuan 2022-09-22
 */
function initDocument()
{
	initLookUp();
	defindTitleStyle();
	initButton();
	initButtonWidth();
	initBindEquipData();
	initDataGrid();
}

/**
 * @desc 加载被绑定设备信息
 * @author zouxuan 2022-09-22
 */
function initBindEquipData()
{
	//文本内容赋值
	//$("#id").text("内容");
	
	//有图片显示图片,无图片显示默认样式
	var ExceptionID=getElementValue("ExceptionID");   //盘盈ID
	$.m({
			ClassName:"web.DHCEQ.Plat.LIBPicture",
			MethodName:"GetPiclistByExceptionID",
			ExceptionID:ExceptionID
		},function(data){
		if(data!="")
		{
			var imageUrl=data;
			$("#Image").attr("src",imageUrl);
			$("#Image").css("display","block");
			$("#DefaultImage").css("display","none");
		}
	});
}

/**
 * @desc 界面表格加载
 * @author zouxuan 2022-09-22
 */
function initDataGrid()
{
	$HUI.datagrid("#tDHCEQInventoryBindList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryBindList",
				ExceptionID:getElementValue("ExceptionID"),
				Equip:getElementValue("EquipName"),
				Model:getElementValue("ModelDR"),
				StoreLocDR:getElementValue("StoreLocDR"),
				InPlan:getElementValue("InPlan"),
				DisplayFlag:getElementValue("DisplayFlag")
		},
		border:false,
	    fit:true,
		fitColumns:true,
	    singleSelect:false,
	    rownumbers: false, //不显示行号
	    showHeader:false, //影藏表头
	    columns:[[
        	{field:'id',hidden:'true',align:'center'},  //id影藏列
        	{field:'img',width:320,align:'center',formatter:datagridImgView},  //图片显示列
        	{field:'text',width:600,formatter:datagridTextInfo},  //文本显示列
        	{field:'button',width:100,align:'center',formatter:datagridButton}  //操作按钮列
    	]],
		pagination:true,
		pageSize:4,
		pageNumber:1,
		pageList:[4,8,12,16,20],
        onLoadSuccess: function (){
            $("a[name='opera']").linkbutton({text:'绑定'}); //操作按钮渲染
        }

	});
}

/**
 * @desc 列表图片加载html
 * @author zouxuan 2022-09-22
 * @input value 单元格值
 * @input row 行数据
 * @input index 行位置
 * @output 表格图片加载html
 */
function datagridImgView(value, row, index)
{
	var bindEquipID=row["TEquipID"];
	var PLRowID=tkMakeServerCall("web.DHCEQ.Plat.LIBPicture","GetPictureByEquip", bindEquipID);
	if(PLRowID){
		//存在图片时  台账默认图片
		//var imgUrl=tkMakeServerCall("web.DHCEQ.Process.DHCEQPicture","GetFtpStreamSrcByPLRowID", PLRowID);
		var imgUrl="web.DHCEQ.Lib.DHCEQStreamServer.cls?PICLISTROWID="+PLRowID
		return '<img src="'+imgUrl+'" style="width: -moz-calc(100%  - 20px);width: -webkit-calc(100%  - 20px);width:calc(100% - 20px);height:200px;padding:10px;">';

　　}else{
		//无图片时
		var imgUrl="../images/eq-defualt.png";
		return '<div id="DefaultImage" style="height:200px;line-height:200px;background-color:#F5F7F5;text-align:center;position:relative;">'+
               '<div style="position:absolute;left:50%;transform:translate(-50%);">'+
               '<sapn style="padding:20px;background:url('+imgUrl+') no-repeat center;"></sapn>'+
               '<span style="font-size:20px;color:#666;">暂无图片</span></div></div>';
　　}
}

/**
 * @desc 列表文本显示加载html
 * @author zouxuan 2022-09-22
 * @input value 单元格值
 * @input row 行数据
 * @input index 行位置
 * @output 表格图片加载html
 */
function datagridTextInfo(value, row, index)
{
	return '<div><p class="eq-invbind-text"><span style="font-size:18px;">No.'+(index+1)+'</span>&nbsp&nbsp<span style="font-weight:700;font-size:18px;">'+row.TEquipName+'</span>&nbsp<span>（'+row.TEquipNo+'）</span></p>'+
			'<p class="eq-invbind-text"><span>规格型号：'+row.TModel+'</span>&nbsp&nbsp<span>出厂编号：'+row.TLeaveFactoryNo+'</span></p>'+
			'<p class="eq-invbind-text"><span>'+row.TInventoryNo+'&nbsp'+row.TPlanName+'</span><span class="eq-invbind-status eq-invbind-color4">'+row.TILStatusDesc+'</span></p>'+   //eq-invbind-color样式定义在csp中
			'<p class="eq-invbind-text"><span>科室：'+row.TBillStoreLoc+'</span>&nbsp&nbsp<span>存放地点：'+row.TPlace+'</span></p></div>';
}

/**
 * @desc 列表按钮显示加载html
 * @author zouxuan 2022-09-22
 * @output 表格图片加载html
 */
function datagridButton(value, row, index)
{
	var bindEquipID=row["TEquipID"];
	var iLRowID=row["TILRowID"];
	return '<a href="#" onclick="bindClick(&quot;'+bindEquipID+'&quot;,&quot;'+iLRowID+'&quot;)" class="hisui-linkbutton" name="opera" data-options="stopAllEventOnDisabled:true"></a>';
}

/**
 * @desc 表单查询按钮响应函数
 * @author zouxuan 2022-09-22
 */
function BFind_Clicked()
{

	initDataGrid();
}

/**
 * @desc 列表绑定按钮响应函数
 * @author zouxuan 2022-09-22
 */
function bindClick(bindEquipID, iLRowID)
{
	var ExceptionID=getElementValue("ExceptionID")
	var TempNo=getElementValue("TempID")
	
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","BindEquip", ExceptionID,TempNo,bindEquipID,iLRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('','','',"绑定成功");
	//	websys_showModal("close"); 
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}

/**
 * @desc 列表上方切换按钮响应事件
 * @author zouxuan 2022-09-22
 * @input obj dom对象
 * @input type 切换按钮类型 InvAll:全部 InvLoss:盘亏 InvUn:未盘 InvFind:待查找
 */
function invStatusSearch(obj,type)
{
	console.log(type)
	//按钮背景色改变
	$(obj).parent().find("a").css("background-color","#CCCCCC");
	$(obj).css("background-color","#40A2DE");
	if (type=="InvAll") { setElement("DisplayFlag","") }
	if (type=="InvLoss") { setElement("DisplayFlag","3") }
	if (type=="InvUn") { setElement("DisplayFlag","") }
	if (type=="InvFind") { setElement("DisplayFlag","4") }
	BFind_Clicked();
	
	
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	if(elementID=="Model") {setElement("ModelDR","")}  //Modefied by zc0126 2022-12-26 元素清空
	return;
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="StoreLocDR_DDesc") {setElement("StoreLocDR",rowData.TRowID)}
	if(elementID=="Model") {setElement("ModelDR",rowData.TRowID)}
}
