/**
 * @desc ������ں���
 * @author zouxuan 2022-09-22
 */
$(function(){
	$(function(){$("#Loading").fadeOut("fast");});
	initDocument();
});

/**
 * @desc �����ʼ������
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
 * @desc ���ر����豸��Ϣ
 * @author zouxuan 2022-09-22
 */
function initBindEquipData()
{
	//�ı����ݸ�ֵ
	//$("#id").text("����");
	
	//��ͼƬ��ʾͼƬ,��ͼƬ��ʾĬ����ʽ
	var ExceptionID=getElementValue("ExceptionID");   //��ӯID
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
 * @desc ���������
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
	    rownumbers: false, //����ʾ�к�
	    showHeader:false, //Ӱ�ر�ͷ
	    columns:[[
        	{field:'id',hidden:'true',align:'center'},  //idӰ����
        	{field:'img',width:320,align:'center',formatter:datagridImgView},  //ͼƬ��ʾ��
        	{field:'text',width:600,formatter:datagridTextInfo},  //�ı���ʾ��
        	{field:'button',width:100,align:'center',formatter:datagridButton}  //������ť��
    	]],
		pagination:true,
		pageSize:4,
		pageNumber:1,
		pageList:[4,8,12,16,20],
        onLoadSuccess: function (){
            $("a[name='opera']").linkbutton({text:'��'}); //������ť��Ⱦ
        }

	});
}

/**
 * @desc �б�ͼƬ����html
 * @author zouxuan 2022-09-22
 * @input value ��Ԫ��ֵ
 * @input row ������
 * @input index ��λ��
 * @output ���ͼƬ����html
 */
function datagridImgView(value, row, index)
{
	var bindEquipID=row["TEquipID"];
	var PLRowID=tkMakeServerCall("web.DHCEQ.Plat.LIBPicture","GetPictureByEquip", bindEquipID);
	if(PLRowID){
		//����ͼƬʱ  ̨��Ĭ��ͼƬ
		//var imgUrl=tkMakeServerCall("web.DHCEQ.Process.DHCEQPicture","GetFtpStreamSrcByPLRowID", PLRowID);
		var imgUrl="web.DHCEQ.Lib.DHCEQStreamServer.cls?PICLISTROWID="+PLRowID
		return '<img src="'+imgUrl+'" style="width: -moz-calc(100%  - 20px);width: -webkit-calc(100%  - 20px);width:calc(100% - 20px);height:200px;padding:10px;">';

����}else{
		//��ͼƬʱ
		var imgUrl="../images/eq-defualt.png";
		return '<div id="DefaultImage" style="height:200px;line-height:200px;background-color:#F5F7F5;text-align:center;position:relative;">'+
               '<div style="position:absolute;left:50%;transform:translate(-50%);">'+
               '<sapn style="padding:20px;background:url('+imgUrl+') no-repeat center;"></sapn>'+
               '<span style="font-size:20px;color:#666;">����ͼƬ</span></div></div>';
����}
}

/**
 * @desc �б��ı���ʾ����html
 * @author zouxuan 2022-09-22
 * @input value ��Ԫ��ֵ
 * @input row ������
 * @input index ��λ��
 * @output ���ͼƬ����html
 */
function datagridTextInfo(value, row, index)
{
	return '<div><p class="eq-invbind-text"><span style="font-size:18px;">No.'+(index+1)+'</span>&nbsp&nbsp<span style="font-weight:700;font-size:18px;">'+row.TEquipName+'</span>&nbsp<span>��'+row.TEquipNo+'��</span></p>'+
			'<p class="eq-invbind-text"><span>����ͺţ�'+row.TModel+'</span>&nbsp&nbsp<span>������ţ�'+row.TLeaveFactoryNo+'</span></p>'+
			'<p class="eq-invbind-text"><span>'+row.TInventoryNo+'&nbsp'+row.TPlanName+'</span><span class="eq-invbind-status eq-invbind-color4">'+row.TILStatusDesc+'</span></p>'+   //eq-invbind-color��ʽ������csp��
			'<p class="eq-invbind-text"><span>���ң�'+row.TBillStoreLoc+'</span>&nbsp&nbsp<span>��ŵص㣺'+row.TPlace+'</span></p></div>';
}

/**
 * @desc �б�ť��ʾ����html
 * @author zouxuan 2022-09-22
 * @output ���ͼƬ����html
 */
function datagridButton(value, row, index)
{
	var bindEquipID=row["TEquipID"];
	var iLRowID=row["TILRowID"];
	return '<a href="#" onclick="bindClick(&quot;'+bindEquipID+'&quot;,&quot;'+iLRowID+'&quot;)" class="hisui-linkbutton" name="opera" data-options="stopAllEventOnDisabled:true"></a>';
}

/**
 * @desc ����ѯ��ť��Ӧ����
 * @author zouxuan 2022-09-22
 */
function BFind_Clicked()
{

	initDataGrid();
}

/**
 * @desc �б�󶨰�ť��Ӧ����
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
		messageShow('','','',"�󶨳ɹ�");
	//	websys_showModal("close"); 
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}

/**
 * @desc �б��Ϸ��л���ť��Ӧ�¼�
 * @author zouxuan 2022-09-22
 * @input obj dom����
 * @input type �л���ť���� InvAll:ȫ�� InvLoss:�̿� InvUn:δ�� InvFind:������
 */
function invStatusSearch(obj,type)
{
	console.log(type)
	//��ť����ɫ�ı�
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
	if(elementID=="Model") {setElement("ModelDR","")}  //Modefied by zc0126 2022-12-26 Ԫ�����
	return;
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="StoreLocDR_DDesc") {setElement("StoreLocDR",rowData.TRowID)}
	if(elementID=="Model") {setElement("ModelDR",rowData.TRowID)}
}
