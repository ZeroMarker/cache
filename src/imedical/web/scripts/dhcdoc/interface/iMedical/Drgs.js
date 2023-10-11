/*
Creater:	jm
CreateDate��2023-03-01
Description:����Drgsͳһ��װJS
*********************************************
*����ǰ��˶ԡ�DHCDoc.Interface.Inside.Drgs.PreGroupChsWebServicePort�������ַ�Ƿ���ȷ
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var DHCDrgsObj = {
		Name:"iMedical_Drgs",
		//���¼��
		Diag:{
			//��ʼ��
			xhrRefresh:function(EpisodeID,PAAdmType) {
				DrgsFuncs.Refresh(EpisodeID,PAAdmType);
			},
			//��˺�
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
		//��ʼ��
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
	                $.messager.alert("Drgs��Ϣ��ȡʧ��!",rtn);
	            }else{
	                DrgsFuncs.InitDrgsTable(EpisodeID);
					//���������¼�
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
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">DRG����: </label>"+GROUP_DESC+"("+GROUP_CODE+")"
	            //     html=html+"</div>"
	            //     html=html+"<div class=\"col-xs-12\">"
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">DRGȨ��: </label>"+WEIGHT
	            //     html=html+"</div>"
	            //     html=html+"<div class=\"col-xs-12\">"
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">֧����׼: </label>"+STD_FEE
	            //     html=html+"</div>"
	            //     html=html+"<div class=\"col-xs-12\">"
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">���ñ���: </label>"+FEE_RATIO
	            //     html=html+"</div>"
	            //     html=html+"<div class=\"col-xs-12\">"
	            //         html=html+"<label style=\"font-weight: 700;margin-bottom: 5px;display: inline-block;\">����ӯ��ֵ: </label>"+PROFIT
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
	        title=title+"<span>DRG/DIP������</span>";
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
		//����
		DrgsDetail:function (EpisodeID){
			var Url=tkMakeServerCall("DHCDoc.Interface.Inside.Drgs.MainPort","GetDrgsDetailUrl",EpisodeID);
	        if (Url==""){
	            $.messager.alert($g("��ϸ��Ϣ��ַ�����ڣ�"));
	            return 	
	        }
	        websys_showModal({
	            url:Url,
	            title:$g('���ܷ�����Ϣ����'),
	            width:1200,height:760
	        });
		}
	}
})
