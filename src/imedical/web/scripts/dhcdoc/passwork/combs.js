/*
 * @Author: qiupeng
 * @Date: 2022-10-24 14:43:20
 * @LastEditors: qiupeng
 * @LastEditTime: 2022-10-24 16:02:04
 * @FilePath: \gcpbc\com\comtpl.js
 * @Description: ���౾ҵ�񹫹�����
 * 
 * Copyright (c) 2022 by qiupeng, All Rights Reserved. 
 */
var TOOL = {
    reservedToHtml: function (str) {
        var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
                            "&#39;":"'", "&amp;":"&", "&#38;":"&"};
        return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
            return replacements[v];		
        });
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ���ز�����Ϣ��
     * @param {*} EpisodeID
     * @param {*} PatientID
     * @return {*}
     */
     LoadBar: function (EpisodeID,PatientID) {
        //dhcdoc.in.patient.banner.csp
        EpisodeID=EpisodeID||"",PatientID=PatientID||"";
        if(typeof InitPatInfoBanner=='function'){
            return InitPatInfoBanner(EpisodeID,PatientID);
        }
        $.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:EpisodeID},function(html){
            if (html!=""){
                $(".patientbar").data("patinfo",html);
                if ("function"==typeof TOOL.InitPatInfoHover) {TOOL.InitPatInfoHover();}
                else{$(".PatInfoItem").html(TOOL.reservedToHtml(html))}
                $(".PatInfoItem").find("img").eq(0).css("top",0);
                
            }else{
                $(".PatInfoItem").html("��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�");
            }
        });
    },
    InitPatInfoHover: function () {
        var btnsWidth = 50;
        //if (patientListPage!="") btnsWidth = 150;
        var html = $(".patientbar").data("patinfo");
        $(".PatInfoItem").html(TOOL.reservedToHtml(html)).css({height:30,overflow:'hidden',paddingRight:10});
        $(".PatInfoItem").css('width',$(".patientbar").width()-btnsWidth);
        $(".PatInfoItem").popover('destroy');
        setTimeout(function(){
            var html = $(".patientbar").data("patinfo");
            if (($(".PatInfoItem")[0].offsetHeight+13)<$(".PatInfoItem")[0].scrollHeight) {
                $(".PatInfoItem").popover({
                    width:$(".PatInfoItem").width()+16,trigger:'hover',
                    arrow:false,style:'patinfo',
                    content:"<div class='patinfo-hover-content'>"+TOOL.reservedToHtml(html)+"</div>"
                });
                $(".PatInfoItem").append('<div style="position:absolute;top:0px;right:0px;">...</div>')
            }
        },500);
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ���ز���
     * @return {*}
     */
    BLHandler: function () {
        var lnk= "websys.chartbook.hisui.csp?"+"EpisodeID="+ServerObj.EpisodeID;	//DHC.Doctor.DHCEMRbrowse
        lnk = lnk +"&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse"
        //window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=1300,height=1000');
        var _content ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+lnk+"' style='padding:10px;'></iframe>" ;
        websys_showModal({
            //url:lnk,
            content:_content,
            iconCls:'icon-w-edit',
            title:'�������',
            width:1300,
            height:800
        })
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ��������
     * @return {*}
     */
    LinkRef_Handler: function () {
        var url="dhcem.patemrque.csp?&EpisodeID="+ServerObj.EpisodeID+"&PatientID="+ServerObj.PatientID+"&targetName=Attitude"+"&TextValue="; //+obj.text;
		window.parent.InsQuote = function (result) {
			websys_showModal("close");
			if (result){
				if ($("#"+PageLogicObj.c_Focus).val() == ""){
					$("#"+PageLogicObj.c_Focus).val(result);
				}else{
					$("#"+PageLogicObj.c_Focus).val($("#"+PageLogicObj.c_Focus).val()  +"\r\n"+ result);
				}
			}
		}
		websys_showModal({
			url:url,
			title:'����',
			iconCls:'icon-w-edit',
			width:1300,height:600,
			CallBackFunc:function(result){
				websys_showModal("close");
				if (result){
					if ($("#"+PageLogicObj.c_Focus).val() == ""){
						$("#"+PageLogicObj.c_Focus).val(result.innertTexts);
					}else{
						$("#"+PageLogicObj.c_Focus).val($("#"+PageLogicObj.c_Focus).val()  +"\r\n"+ result.innertTexts);
					}
				}
			}
		});
    }
}

var TPL = {
    _version: "1.0.0",
    
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ��д��־������
     * @return {*}
     */
    initFillFlagCombox: function () {
        $HUI.combobox("#InFillFlag",{
            valueField:'id', 
            textField:'text',
            editable:false,
            value:'',
            data:[
                {id:'',text:$g('ȫ��')}
                ,{id:'1',text:$g('����д')}
                ,{id:'2',text:$g('δ��д')}
            ]
        })

	},
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ����/����switchbox����
     * @return {*}
     */
    initSwitch: function () {
        return $HUI.switchbox('#SelfUser',{
            onText:$g("����"),
            offText:$g("����"),
            onClass:'info',
            offClass:'warning',
            size:"small",
            animated:true,
            onSwitchChange:function(e,obj){
               TPL.FindGrid();
            }
        })	
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ���ð�ť����״̬
     * @param {*} flag
     * @return {*}
     */
    setTypeButton: function (flag) {
        if (flag == "init") {
            var TypeAddOPT = $("#BAdd").linkbutton('options');
            var TypeEditOPT = $("#BEdit").linkbutton('options');
            var BContentOPT = $("#BContent").linkbutton('options');
            
            TypeAddOPT.stopAllEventOnDisabled=true;	
            TypeEditOPT.stopAllEventOnDisabled=true;
            BContentOPT.stopAllEventOnDisabled=true;
    
            $("#BAdd").linkbutton('disable');	
            $("#BEdit").linkbutton('disable');	
            $("#BContent").linkbutton('disable');	
            
        } else if (flag == "disable") {
            $("#BAdd").linkbutton('disable');
            $("#BEdit").linkbutton('disable');	
            $("#BContent").linkbutton('disable');
        } else if (flag == "enable") {
            $("#BAdd").linkbutton('enable');
            $("#BEdit").linkbutton('enable');	
            $("#BContent").linkbutton('enable');
        } else {}
    },
    CallBack: function () {
        return parent.FindItemCount();
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: �������໼��
     * @return {*}
     */
    BAddHandler: function () {
        var SID = "";
        var URL = "dhcdoc.passwork.nmain.comtpl.add.csp?NID="+ServerObj.NID+"&SID="+SID+"&PType="+ServerObj.PType;
        URL = URL+"&BCDate="+ServerObj.BCDate+"&BCCode="+ServerObj.BCCode
        websys_showModal({
            url:URL,
            iconCls: 'icon-w-add',
            title:'����',
            width:350,height:300,
            CallBackFunc: TPL.CallBack
        })
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: �޸Ľ��໼��
     * @return {*}
     */
    BEditHandler: function () {
        var selected = PageLogicObj.m_ItemGrid.getSelected();
        if (!selected) {
            $.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
            return false;
        }
        var SID = selected.SID;
        var URL = "dhcdoc.passwork.nmain.comtpl.add.csp?NID="+ServerObj.NID+"&SID="+SID+"&PType="+ServerObj.PType;
        URL = URL+"&BCDate="+ServerObj.BCDate+"&BCCode="+ServerObj.BCCode
        websys_showModal({
            url:URL,
            iconCls: 'icon-w-add',
            title:'�޸�',
            width:350,height:300,
            CallBackFunc: TPL.CallBack
        })
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ��д��������
     * @return {*}
     */
    BContentHandler: function (option) {
        var selected = PageLogicObj.m_ItemGrid.getSelected();
        if (!selected) {
            $.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
            return false;
        }
        var SID = selected.SID;
        var URL = option.url+"?NID="+ServerObj.NID+"&SID="+SID+"&PType="+ServerObj.PType;
        URL = URL+"&BCDate="+ServerObj.BCDate+"&BCCode="+ServerObj.BCCode+"&EpisodeID="+selected.EpisodeID;
        websys_showModal({
            url:URL,
            iconCls: 'icon-w-add',
            title:'��д��������',
            width:option.width,height:option.height,
            CallBackFunc: TPL.FindGrid,
            NextOrPrev:TPL.NextOrPrev
        })
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ��ѯ������ϸ�б�
     * @return {*}
     */
    FindGrid: function () {
        var SelfSwitch = PageLogicObj.m_SelfSwitch.getValue()?1:0,
		C1 = String.fromCharCode(1),
		InFillFlag = $("#InFillFlag").combobox("getValue");
        var InExt = SelfSwitch+C1+InFillFlag
        PageLogicObj.m_ItemGrid.reload({
            ClassName : "DHCDoc.PW.BS.NSub",
                QueryName : "ItemSubQry",
                NID:ServerObj.NID,
                BCDate:ServerObj.BCDate,
                LocId:session['LOGON.CTLOCID'],
                UserId:session['LOGON.USERID'],
                InBCCode:ServerObj.BCCode,
                InPType:ServerObj.PType,
                InPatNo:$("#i-patno").val(),
                InExt:InExt

        });
        return false;
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ������¼�
     * @param {*} e
     * @return {*}
     */
    DocumentOnKeyDown: function (e) {
        if (window.event){
            var keyCode=window.event.keyCode;
            var type=window.event.type;
            var SrcObj=window.event.srcElement;
        }else{
            var keyCode=e.which;
            var type=e.type;
            var SrcObj=e.target;
        }
        if (keyCode==13) {
            if(SrcObj && SrcObj.id.indexOf("i-patno")>=0){
                var PatNo=$('#i-patno').val();
                //if (PatNo=="") return;
                if ((PatNo.length<10)&&(PatNo!="")) {
                    for (var i=(10-PatNo.length-1); i>=0; i--) {
                        PatNo="0"+PatNo;
                    }
                }
                $('#i-patno').val(PatNo);
                TPL.FindGrid();
                return false;
            }
            return true;
        }
    },
    /**
     * @name: qp
     * @date: 2022-10-24
     * @description: ��һ��/��һ��
     * @param {*} action
     * @return {*}
     */
    NextOrPrev: function (action) {	//��0��ʼ
        var rtnOBJ = {
            "NID":undefined,
            "SID" :undefined,
            "PType": undefined,
            "EpisodeID":undefined,
            "BCDate": undefined,
            "BCCode": undefined,
            "Success":true,
            "Msg":""
        }
        var data = PageLogicObj.m_ItemGrid.getData();
        var pageSize = data.total;	//�ܼ�¼��	
        var selectedOld = PageLogicObj.m_ItemGrid.getSelected();
        var oldRowIndex = PageLogicObj.m_ItemGrid.getRowIndex(selectedOld);
        var newIndex = "-1"
        if (action == "next") {
            newIndex = oldRowIndex + 1;
            if (newIndex >= pageSize) {
                $.extend( rtnOBJ ,
                    {
                        "Msg":"�������һ��!",
                        "Success" :false
                    }
                    
                )
                return rtnOBJ;
            }
        } else {
            newIndex = oldRowIndex - 1
            if (newIndex < 0) {
                $.extend( rtnOBJ ,
                    {
                        "Msg":"���ǵ�һ��!",
                        "Success" :false
                    }
                    
                )
                return rtnOBJ;
            }
        }
        PageLogicObj.m_ItemGrid.selectRow(newIndex);
        var selected = PageLogicObj.m_ItemGrid.getSelected();
        if (!selected) {

            $.extend( rtnOBJ ,
                {
                    "Msg":"�������һ��!",
                    "Success" :false
                }
                
            )
            return rtnOBJ;
        }
        if (rtnOBJ.Success) {
            $.extend( rtnOBJ ,
                {
                    "NID":selected["NID"],
                    "SID" :selected["SID"],
                    "PType": selected["PType"],
                    "EpisodeID":selected["EpisodeID"],
                    "BCDate": selected["BCDate"],
                    "BCCode": selected["BCCode"]
                }
                
            )
        }
        
        return rtnOBJ;
    }

}