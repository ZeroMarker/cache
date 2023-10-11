///add by ZY   2826780  20220926

//modified by ZY 2023-02-02 bug:3200545\3200551\3200747
var PMSourceType=getElementValue("PMSourceType");
var PMSourceID=getElementValue("PMSourceID");
var PAManufactoryDR=getElementValue("PAManufactoryDR");
var VendorDR=getElementValue("VendorDR");
///modified by ZY20230320 bug:3254075
var Vendor=tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID","prov",VendorDR)
setElement("Vendor",Vendor)
var Vendor=getElementValue("Vendor");
var topLevel=getElementValue("topLevel");
var curLevel=getElementValue("curLevel");
///modified by ZY20230214 bug:3244516
var ReadOnly=getElementValue("ReadOnly");
var deletePARowID=""
$(function(){
    initDocument();
});
function initDocument(){
    initUserInfo();        
    initMessage("InStock"); //��ȡ����ҵ����Ϣ
    initLookUp(); //��ʼ���Ŵ�
    initButton();
    initEvent();
    //initButtonWidth();
    fillData("")
	if ((PMSourceType!="")&&(PMSourceID!=""))
	{
		if (PAManufactoryDR==""){
			
			alertShow("�������Ҳ���Ϊ��!");
			disableElement("BProxyAuthorization",true);
			disableElement("BSave",true);
		}
	}
	//modified by ZY20230209  bug:3163825  ��Ʒ��ȨUI����
    $("#vPDesc").text(getElementValue("PDesc"));
    $("#vPModels").text(getElementValue("PModels"));
    $("#vPManufactory").text(getElementValue("PManufactory"));
    $("#vVendor").text(getElementValue("Vendor"));
    
    ///modified by ZY20230214 bug:3244516
    if (ReadOnly!="")
    {
        disableElement("BProxyAuthorization",true)
        disableElement("BSave",true)
    }
};

function initEvent()
{
    if (jQuery("#BProxyAuthorization").length>0)
    {
        jQuery("#BProxyAuthorization").linkbutton({iconCls: 'icon-w-reset'});
        jQuery("#BProxyAuthorization").on("click", BProxy_Click);
        jQuery("#BProxyAuthorization").linkbutton({text:'ѡ��������Ȩ��'});
    }
}
/*
function fillDataByChoice()
{
    var Date=getElementValue("Date");
    var User=getElementValue("User");
    var Job=getElementValue("Job");
    var nodestr=getElementValue("nodestr");
    var ChoiceProductDR=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","GetChoiceProductDR",nodestr,Date,User,Job)
    fillData(ChoiceProductDR)
}*/

///��"ѡ��������Ȩ��"ѡ�����ݺ�,���ݲ���PMProductDR
function fillData(PMProductDR)
{
	//modified by ZY20230209  bug:3163825  ��Ʒ��ȨUI����
    var firstFlag=0
    if (PMProductDR=="")    //�����յ��򿪽���ʱ
    {
        var PMProductDR=getElementValue("PMProductDR");
        if (PMProductDR=="")
        {
            initPanel('close',2,topLevel)
            return;
        }
        firstFlag=1
    }
    jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","GetProxyAuthorizationByProductDR",PMProductDR)
    //messageShow("","","",jsonData)
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
    setElementByJson(jsonData.Data);
    curLevel=getElementValue("curLevel");
    if (curLevel==0) curLevel=1
    
    for (var i = 1; i <= topLevel; i++) 
    {
        if (i<=curLevel)
        {
            initPanel("open",i,i,firstFlag)
        }
        else
        {
            initPanel("close",i,i,firstFlag)
        }
    }
}
//modified by ZY20230209  bug:3163825  ��Ʒ��ȨUI����
function initPanel(action,beginLevel,endLevel,firstFlag)
{
    for (var i = beginLevel; i <= endLevel; i++) 
    {
        $("#Authorization"+i).panel(action);        
        var flag=0  //close
        if (action=="open") flag=1  //open
        setRequiredElements("PAAuthorizer_VDesc"+i+"^PAAuthorized_VDesc"+i+"^PADesc"+i+"^PAAvailableFromDate"+i+"^PAAvailableToDate"+i,flag)
        if (flag==0)
        {
            deletePARowID
            var PARowID=getElementValue("PARowID"+i);
            if (PARowID!="")
            {
                if (deletePARowID=="") deletePARowID=PARowID
                else
                {
                    deletePARowID=deletePARowID+","+PARowID
                }
            }
            clearData(i)
        }
        else
        {
            var PARowID=getElementValue("PARowID"+i);
            if (PARowID!="")
            {
                initImage(PARowID,i)
            }
            
            if (jQuery("#BProductMap"+i).length>0)
            {
                jQuery("#BProductMap"+i).linkbutton({iconCls: 'icon-w-list'});
                jQuery("#BProductMap"+i).on("click", BProductMap_Click);
                jQuery("#BProductMap"+i).linkbutton({text:'��Ȩ��Ʒ'});
            };
            
            
            if (jQuery("#Image"+i).length>0)
            {
                //jQuery("#Image"+i).linkbutton({iconCls: 'icon-w-import'});
                jQuery("#Image"+i).on("click", BPicture_Click);
                //jQuery("#Image"+i).linkbutton({text:'��Ȩ��Ʒ'});
            };
            if (jQuery("#DefaultImage"+i).length>0)
            {
                //jQuery("#DefaultImage"+i).linkbutton({iconCls: 'icon-w-import'});
                jQuery("#DefaultImage"+i).on("click", BPicture_Click);
                //jQuery("#DefaultImage"+i).linkbutton({text:'��Ȩ��Ʒ'});
            };
            var PAAuthorizer=getElementValue("PAAuthorizer"+i);
            if (PAAuthorizer!="")
            {
                $("#cPAAuthorizer_VDesc"+i).html('<a href="#" style="margin:0;font-weight:800;text-decoration:underline;" onclick="javascript:pictureInfo('+PAAuthorizer+')">'+"��Ȩ��"+'</a>')
            }
            var PAAuthorized=getElementValue("PAAuthorized"+i);
            if (PAAuthorized!="")
            {
                $("#cPAAuthorized_VDesc"+i).html('<a href="#" style="margin:0;font-weight:800;text-decoration:underline;" onclick="javascript:pictureInfo('+PAAuthorized+')">'+"����Ȩ��"+'</a>')
            }
	    //modified by ZY20230209  bug:3163825  ��Ʒ��ȨUI����  ����ֱ���滻
            if (firstFlag==1)
            {

                $HUI.switchbox('#PALimitFlagSwitch'+i,{
                    onText:'��',
                    offText:'��',
                    onClass:'primary',
                    offClass:'gray',
                    checked:false,
                    onSwitchChange:function(e,obj){
                        //console.log(e);
                        //console.log(obj.id);
                        var curBtn=$(this).attr("id")
                        var index=curBtn.charAt(curBtn.length-1)
                        if(obj.value==true) 
                        {
                            disableElement("BProductMap"+index,false)
                            setElement("PALimitFlag"+index,1)
                        }
                        else
                        {
                            disableElement("BProductMap"+index,true)
                            setElement("PALimitFlag"+index,0)
                        }
                    }
                 })
            }
            var value=getElementValue("PALimitFlag"+i)
            if (value==1) value=true
            if ((value==0)||(value=="")) value=false
            $("#PALimitFlagSwitch"+i).switchbox("setValue",value);
            disableElement("BProductMap"+i,!value )
        }
    }
}

function BProxy_Click()
{
    var PAManufactoryDR=getElementValue("PAManufactoryDR");
    if (PAManufactoryDR=="")
    {
        alertShow("�������Ҳ���Ϊ��!");
        return;
    }
    /*
    var VendorDR=getElementValue("VendorDR");
    if (VendorDR=="")
    {
        alertShow("��Ӧ�̲���Ϊ��!");
        return;
    }*/
    var Date=getElementValue("Date");
    var User=getElementValue("User");
    var Job=getElementValue("Job");
    var nodestr=getElementValue("nodestr");
    var url='dhceq.plat.proxyauthorizationlist.csp?&ManufactoryDR='+PAManufactoryDR+'&VendorDR='+VendorDR+'&Date='+Date+'&User='+User+'&Job='+Job+'&nodestr='+nodestr;
    showWindow(url,"��Ʒ��Ȩ���嵥","","","icon-w-paper","modal","","","large",fillData);
}

function BPicture_Click()
{
    var curBtn=$(this).attr("id")
    var index=curBtn.charAt(curBtn.length-1)
    var PARowID=getElementValue("PARowID"+index);
    if (PARowID=="")
    {
        alertShow("���ȱ�����Ȩ��Ϣ�����ϴ�ͼƬ!");
        return;
    }
    var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=63-4&CurrentSourceID='+PARowID+'&Status=0';
    
    showWindow(str,"ͼƬ��Ϣ","","","icon-w-edit","","","","middle")  //modify by lmm 2020-06-05 UI
}
function BProductMap_Click()
{
    var curBtn=$(this).attr("id")
    var index=curBtn.charAt(curBtn.length-1)
    var PAAuthorizer=getElementValue("PAAuthorizer"+index);
    if (PAAuthorizer=="")
    {
        alertShow("��Ȩ������Ϊ��!");
        return;
    }
    var PAAuthorized=getElementValue("PAAuthorized"+index);
    if (PAAuthorized=="")
    {
        alertShow("����Ȩ������Ϊ��!");
        return;
    }
    var PARowID=getElementValue("PARowID"+index);
    var url='dhceq.plat.productmap.csp?&PMSourceType=4&PMSourceID='+PARowID+'&PAAuthorizer='+PAAuthorizer+'&PAAuthorized='+PAAuthorized;
    showWindow(url,"��Ȩ��Ʒ��ϸ","","","icon-w-paper","modal","","","small");
}
function clearData(index)
{
    setElement("PARowID"+index,"")
    setElement("PAManuFactoryDR"+index,"")
    setElement("PAAuthorizer"+index,"")
    setElement("PAAuthorizer_VDesc"+index,"")
    setElement("PAAuthorized"+index,"")
    setElement("PAAuthorized_VDesc"+index,"")
    setElement("PADesc"+index,"")
    setElement("PANo"+index,"")
    setElement("PAAuthorizDate"+index,"")
    setElement("PAAvailableFromDate"+index,"")
    setElement("PAAvailableToDate"+index,"")
    setElement("PAContext"+index,"") 
    setElement("PARemark"+index,"") 
    setElement("PALimitFlag"+index,"") 
    setElement("PAActiveFlag"+index,"") 
    setElement("PAInvalidFlag"+index,"") 
    setElement("PAUpdateUserDR"+index,"") 
    setElement("PAUpdateDate"+index,"") 
    setElement("PAUpdateTime"+index,"") 
    setElement("PAStatus"+index,"") 
    setElement("PAHold1"+index,"") 
    setElement("PAHold2"+index,"") 
    setElement("PAHold3"+index,"") 
    setElement("PAHold4"+index,"") 
    setElement("PAHold5"+index,"") 
}
function initImage(PARowID,level)
{
    $.m({
            ClassName:"web.DHCEQ.Plat.LIBPicture",
            MethodName:"GetFirstPicture",
            SourceType:"63-4",
            SourceID:PARowID,
            PicTypeDR:28
        },function(data){
            if(data!="")
            {
                var imageUrl="web.DHCEQ.Lib.DHCEQStreamServer.cls?PICLISTROWID="+data;
                $("#Image"+level).attr("src",imageUrl);
                $("#Image"+level).css("display","block");
                $("#DefaultImage"+level).css("display","none");
            }
    });
}
function BSave_Clicked()
{
	///modified by ZY20230209 bug:3251727
	if (checkMustItemNull()) return;
	var lastPAAuthorized=getElementValue("PAAuthorized"+curLevel)
	var lastPAAuthorized_VDesc=getElementValue("PAAuthorized_VDesc"+curLevel)
	if (Vendor=="")
	{
		SaveData()
	}
	else
	{
		///modified by ZY 20221107 2997060
		messageShow("confirm","info","��ʾ","��ȷ�����һ������Ȩ���Ƿ��ǹ�Ӧ��:"+Vendor+"?","",function(){
			
				if ((lastPAAuthorized!=VendorDR)||(lastPAAuthorized_VDesc!=Vendor))
				{
					messageShow("confirm","info","��ʾ","��"+curLevel+"������Ȩ�߲��ǵ�ǰ��Ʒ�Ĺ�Ӧ��,�Ƿ�Ҫ��������?","",SaveData,function(){return},"ȷ��","ȡ��");
				}
				else
				{
					SaveData()
				}
				return
			},function(){
				return
			},"��","����");
	}
}
function SaveData()
{
    var PAManufactoryDR=getElementValue("PAManufactoryDR")
    var dataList=""
    for (var i = 1; i <= curLevel; i++) 
    {
        //var curPAAuthorizerID="PAAuthorizer"+i
        //var curPAAuthorizer=getElementValue("PAAuthorizer"+i)
        //if (curPAAuthorizer=="") break;
        var oneRow={}
        jQuery("#Authorization"+i+" input").each(function(){
            var objID=$(this)[0].id;
            if ((objID!=undefined)&&(objID!=""))
            {
                var keyName=objID.substr(0,objID.length-1)
                oneRow[keyName]=getElementValue(objID)
            }
        })
        jQuery("#Authorization"+i+" textarea").each(function(){
            var objID=$(this)[0].id;
            if ((objID!=undefined)&&(objID!=""))
            {
                var keyName=objID.substr(0,objID.length-1)
                oneRow[keyName]=getElementValue(objID)
            }
        })
        oneRow["PAManufactoryDR"]=PAManufactoryDR
        var oneRow=JSON.stringify(oneRow)
        if (dataList=="")
        {
            dataList=oneRow
        }
        else
        {
            dataList=dataList+getElementValue("SplitRowCode")+oneRow  //add by zx 2019-07-24 �ָ������޸�
        }
        
    }
    var data=getElementValue("PMProductDR");
    data=data+"^"+4;    //PMSourceType
    disableElement("BSave",true)
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","SaveProductMap",data,dataList,deletePARowID);
    jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
        var PMSourceType=getElementValue("PMSourceType");
        var PMSourceID=getElementValue("PMSourceID"); 
        var PMProductDR=getElementValue("PMProductDR"); 
        var val="&PMSourceType="+PMSourceType+"&PMSourceID="+PMSourceID+"&PMProductDR="+PMProductDR;
        var url="dhceq.plat.proxyauthorization.csp?"+val;
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
        window.location.href= url;
    }
    else
    {
        disableElement("BSave",false)   //add by csj 2020-03-10 ����ʧ�ܺ�����
        alertShow("������Ϣ:"+jsonData.Data);
        return
    }
}
function setSelectValue(elementID,rowData)
{
    var level=elementID.charAt(elementID.length-1)
    var nextLevel=parseInt(level)+1
    var vElementID=elementID.split("_")
    var ID=vElementID[0]
    var IDDesc=vElementID[1].substr(0,vElementID[1].length-1)
    setElement(ID+level,rowData.TRowID)
    if (ID=="PAAuthorizer")
    {
        var PAAuthorizer=getElementValue("PAAuthorizer"+level);
        if (PAAuthorizer!="")
        {
            $("#cPAAuthorizer_VDesc"+level).html('<a href="#" style="margin:0;font-weight:800;text-decoration:underline;" onclick="javascript:pictureInfo('+PAAuthorizer+')">'+"��Ȩ��"+'</a>')
        }
    }
    else if (ID=="PAAuthorized")
    {
        var PAAuthorized=getElementValue("PAAuthorized"+level);
        if (PAAuthorized!="")
        {
            $("#cPAAuthorized_VDesc"+level).html('<a href="#" style="margin:0;font-weight:800;text-decoration:underline;" onclick="javascript:pictureInfo('+PAAuthorized+')">'+"����Ȩ��"+'</a>')
        }
    }
    //if ((rowData.TRowID!=VendorDR)&&(VendorDR!=""))
    if (rowData.TRowID!=VendorDR)
    {
        if (nextLevel>topLevel)
        {
            alertShow("��ʾ��Ϣ:Ŀǰ��֧��"+topLevel+"����Ȩ����!(�����Ȩ��Ӧ���ǵ�ǰ��Ʒ��Ӧ��.)");
            setElement(ID+level,"")
            setElement(ID+"_"+IDDesc+level,"")
        }
        else
        {
            //$("#Authorization"+nextLevel).panel('open');
            initPanel('open',nextLevel,nextLevel)
            setElement("PAAuthorizer"+nextLevel,rowData.TRowID)
            setElement("PAAuthorizer_VDesc"+nextLevel,rowData.TName)
        }
    }
    else
    {
        curLevel=level
        initPanel('close',nextLevel,topLevel)
    }
}

function clearData(elementID)
{
    setElement(elementID+"DR","")
}

function pictureInfo(id)
{
    if (id=="")
    {
        alertShow("������Ȩ��Ϣ���ٲ鿴ͼƬ��Ϣ!");
        return;
    }
    //63-1��Ӧ������ 63-2������������ 63-3����֤�� 63-4��Ӧ����Ȩ
    var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=63-1&CurrentSourceID='+id+'&Status=0';
    //var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=63-4&CurrentSourceID='+PARowID+'&Status=0';
    showWindow(str,"ͼƬ��Ϣ","","","icon-w-edit","","","","middle")
}
