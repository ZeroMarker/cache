/*
Creater:	jm
CreateDate：2023-03-01
Description:东华Drgs统一封装JS
*********************************************
*开启前需核对【DHCDoc.Interface.Inside.Drgs.PreGroupChsWebServicePort】服务地址是否正确
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var DHCDrgsObj = {
		Name:"iMedical_Drgs",
		//诊断录入
		Diag:{
			//初始化
			xhrRefresh:function(EpisodeID,PAAdmType) {
				DrgsFuncs.Refresh(EpisodeID,PAAdmType);
			},
			//审核后
			AfterUpdate:function(EpisodeID,PAAdmType) {
				DrgsFuncs.Refresh(EpisodeID,PAAdmType);
			}
		},
		Funcs:{
			DrgsRefresh:function(EpisodeID,PAAdmType) {
				DrgsFuncs.Refresh(EpisodeID,PAAdmType);
			},
			DrgsDetail:function(EpisodeID) {
				DrgsFuncs.DrgsDetail(EpisodeID);
			}
		}
	}
	Common_ControlObj.InterfaceArr.push(DHCDrgsObj)
	//
	var DrgsFuncs={
		//初始化
		Refresh:function(EpisodeID,PAAdmType){
			if (PAAdmType != "I") {
		        return true;
		    }
	        var rtn=$.m({
			    ClassName:"DHCDoc.Interface.Inside.Drgs.MainPort",
			    MethodName:"SendtoDrgs",
			    EpisodeID:EpisodeID,
			},function(rtn){
	            var rtbarry=rtn.split("^")
	            if (rtbarry[0]!=0){
	                $.messager.alert("Drgs信息获取失败!",rtn);
	            }else{
	                DrgsFuncs.InitDrgsTable(EpisodeID);
					//定义详情事件
					$("#DrgsShow").click(function() {
						Common_ControlObj.Interface("DrgsDetail",{
							EpisodeID: EpisodeID
						})
					})
	            }
	        })
		},
		InitDrgsTable:function(EpisodeID){
			//$("#drgdiv").html(gethtml())
	        var rtnjson=tkMakeServerCall("DHCDoc.Interface.Inside.Drgs.MainPort","getMesFromDrgs",ServerObj.EpisodeID);
	        var html="",GROUP_DESC="";
	        if (rtnjson!=""){
	            var JsonObj=eval("("+rtnjson+")")

	            var GROUP_DESC="",GROUP_CODE="",WEIGHT="",DRG_RATE="",FEE_RATIO="",STD_FEE="",PROFIT="",FEE_RATIO="",ContentHTML=""
	            // if (typeof JsonObj.result_data.GROUP_DESC!='undefined') {GROUP_DESC=JsonObj.result_data.GROUP_DESC}
	            // if (typeof JsonObj.result_data.GROUP_CODE!='undefined') {GROUP_CODE=JsonObj.result_data.GROUP_CODE}
	            // if (typeof JsonObj.result_data.WEIGHT!='undefined') {WEIGHT=JsonObj.result_data.WEIGHT}
	            // if (typeof JsonObj.result_data.FEE_RATIO!='undefined') {FEE_RATIO=JsonObj.result_data.FEE_RATIO}
	            // if (typeof JsonObj.result_data.STD_FEE!='undefined') {STD_FEE=JsonObj.result_data.STD_FEE}
	            // if (typeof JsonObj.result_data.PROFIT!='undefined') {PROFIT=JsonObj.result_data.PROFIT}
	            if (typeof JsonObj.result_data.HTML!='undefined') {ContentHTML=JsonObj.result_data.HTML}
	            html=html+ContentHTML;
	            // html=html+"<div class=\"row\" style=\"padding-left: 5px;\">"
	            //     html=html+"<div class=\"col-xs-12\">"
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">DRG分组: </label>"+GROUP_DESC+"("+GROUP_CODE+")"
	            //     html=html+"</div>"
	            //     html=html+"<div class=\"col-xs-12\">"
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">DRG权重: </label>"+WEIGHT
	            //     html=html+"</div>"
	            //     html=html+"<div class=\"col-xs-12\">"
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">支付标准: </label>"+STD_FEE
	            //     html=html+"</div>"
	            //     html=html+"<div class=\"col-xs-12\">"
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">费用倍率: </label>"+FEE_RATIO
	            //     html=html+"</div>"
	            //     html=html+"<div class=\"col-xs-12\">"
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">患者盈亏值: </label>"+PROFIT
	            //     html=html+"</div>"
	            // html=html+"</div>"
	        }
	        if (html==""){
	            $('#DrgsMain_Win').window("destroy");
	            return;
	        }
	        if(!$('#DrgsMain_Win').size()){
	            $("body").append("<div id='DrgsMain_Win' class='hisui-window'></div>");
	        }
	        var title="";
	        title=title+"<a id='DrgsShow'  style=\"text-decoration:none;\">"
	        title=title+"<span>DRG/DIP分组结果</span>";
	        title=title+"</a>";
	        $('#DrgsMain_Win').window({
	            //iconCls:"icon-verify",
	            width:"550",
	            height:"360",
	            top:$(window).height()-410,
	            left:$(window).width()-1035,
	            title:title,
	            collapsible:true,
	            maximizable:false,
	            minimizable:false,
	            modal:false,
	            content:html
	        }); 
		},
		//详情
		DrgsDetail:function (EpisodeID){
			var Url=tkMakeServerCall("DHCDoc.Interface.Inside.Drgs.MainPort","GetDrgsDetailUrl",EpisodeID);
	        if (Url==""){
	            $.messager.alert($g("详细信息地址不存在！"));
	            return 	
	        }
	        websys_showModal({
	            url:Url,
	            title:$g('智能分组信息详情'),
	            width:1200,height:760
	        });
		}
	}
})
