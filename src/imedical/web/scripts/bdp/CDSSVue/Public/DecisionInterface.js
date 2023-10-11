/*
* @Author: ��������ƽ̨-ʯ��ΰ
* @Date:   2020-04-14
* @Last Modified by:   ʯ��ΰ
* @Last Modified time: 2020-04-14
* @����:��Ͼ��߹���ģ���̨����python��ajax������װ
*/
$(function () {
    /**
     * @Author ʯ��ΰ
     * @desc ajax��ȡ����������ݣ�����
     * @Last Modified by:   ʯ��ΰ
     * @Last Modified time: 2020-04-14
     */
    function getSuspectDiag(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSuspectedDisease?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                //timeout : 1000, //��ʱʱ�����ã���λ����
                success: function(data){
	                console.log("http://"+InterfaceIP+"/GetSuspectedDisease?PatientUserInfo="+encodeURIComponent(PatientUserInfo))
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                },
//		    ����complete : function(XMLHttpRequest,status){ //������ɺ�����ִ�в���
//					if(status == "timeout"){
//						ajaxTimeOut.abort();
//						console.log("���Ƽ�������ʱ")
//					}
//		    ����}
            });
        })
    }
    /**
     * @Author ʯ��ΰ
     * @desc ajax��ȡ������������
     * @Last Modified by:   ʯ��ΰ
     * @Last Modified time: 2020-04-14
     */
    function getRareDiag(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/GetRareDiseases?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        })
    }
    /**
     * @Author ʯ��ΰ
     * @desc ajax��ȡ�����¼�����
     * @Last Modified by:   ʯ��ΰ
     * @Last Modified time: 2020-04-14
     */
    function getAssistExamByDiag(diag){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSuspectedDisAssistExam?PatientUserInfo="+encodeURIComponent(PatientUserInfo)+"&Disease="+encodeURIComponent(diag),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        })
    }
    /**
     * @Author ʯ��ΰ
     * @desc ajax��ȡ���еļ�����
     * @Last Modified by:   ʯ��ΰ
     * @Last Modified time: 2020-04-14
     */
    function getAllAssistExam(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSuspectedAllAssistExam?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        })
    }
    /**
     * @Author ʯ��ΰ
     * @desc ajax��ȡ����������ݣ��б�
     * @Last Modified by:   ʯ��ΰ
     * @Last Modified time: 2020-04-14
     */
    function getSuspectGrid(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSuspectedDiseaseList?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){    
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        });
    }
    /**
     * @Author ʯ��ΰ
     * @desc ajax��ȡ����µ�֢״����
     * @Last Modified by:   ʯ��ΰ
     * @param {*} diag �������    
     * @Last Modified time: 2020-04-14
    */
    function getSymptoms(diag){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSelectedSymptoms?Disease="+encodeURIComponent(diag)+"&PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        });
    

    }
    /**
     * @Author ʯ��ΰ
     * @desc ajax��ȡ����µļ����������
     * @Last Modified by:   ʯ��ΰ
     * @param {*} diag �������    
     * @Last Modified time: 2020-04-14
    */
    function getDiffDiag(diag){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/GetDiffDisease?PatientUserInfo="+encodeURIComponent(PatientUserInfo)+"&Disease="+encodeURIComponent(diag),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        });
    }
    /**
     * @Author ʯ��ΰ
     * @desc ajax��ȡ���˲���ּ�
     * @Last Modified by:   ʯ��ΰ   
     * @Last Modified time: 2020-04-14
    */
    function getGradingOfDisease() {
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/recom_emerstand?patient_info="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        });

    }

   /**
    * @Author ʯ��ΰ
    * @desc M��ȡ���߼���ʷ��Ϣ(echartsͼ)
    * @Last Modified by:   ʯ��ΰ   
    * @Last Modified time: 2020-04-17
    */
    function getPastDiag(){
	    //fwk
	    /*var DataInfo = "web.DHCBL.MKB.MKBConfig[A]GetConfigValue[A]CDSSdyn20200416[A]";
        var Config = CDSSMakeServerCall(DataInfo);*/
        
        //var Config= tkMakeServerCall("web.DHCBL.MKB.MKBConfig","GetConfigValue","CDSSdyn20200416");
        
        //fwk
	    var DataInfo = "web.CDSS.PatientView.PastDiagnosis[A]GetPastDiagForEcharts[A]"+IDNO+"[A]"+PatientDR+"[A]"+VisitID+"[A]"+Config;
        var data = CDSSMakeServerCall(DataInfo);
        
        //var data = tkMakeServerCall("web.CDSS.PatientView.PastDiagnosis", "GetPastDiagForEcharts", IDNO, PatientDR, VisitID, Config);
        return data
    }
    /**
     * @Author ʯ��ΰ
     * @desc M��ȡ���߼���ʷ������ϸ��Ϣ(���echartsͼ)
     * @param {*} id ����ʷid
     * @Last Modified by:   ʯ��ΰ   
     * @Last Modified time: 2020-04-17
     */
    function GetPastDiagDetail(id){
	    //fwk
	    var DataInfo = "web.CDSS.PatientView.PastDiagnosis[A]GetPastDiagForForm[A]"+id;
        var data = CDSSMakeServerCall(DataInfo);
        
        //var data = tkMakeServerCall("web.CDSS.PatientView.PastDiagnosis","GetPastDiagForForm",id);
        return data;
    }
    /**
    * @Author ʯ��ΰ
    * @desc M��ȡ���߸���ʷ��Ϣ(echartsͼ)
    * @Last Modified by:   ʯ��ΰ   
    * @Last Modified time: 2020-04-20
    */
    function getPersonalInfo(){
	    //fwk
	    /*var DataInfo = "web.DHCBL.MKB.MKBConfig[A]GetConfigValue[A]CDSSdyn20200416";
        var Config = CDSSMakeServerCall(DataInfo);*/
        
        //var Config= tkMakeServerCall("web.DHCBL.MKB.MKBConfig","GetConfigValue","CDSSdyn20200416");
        
        //fwk
	    var DataInfo = "web.CDSS.PatientView.PersonalInfo[A]GetPersoInfoForEcharts[A]"+IDNO+"[A]"+PatientDR+"[A]"+Config;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.PatientView.PersonalInfo","GetPersoInfoForEcharts",IDNO,PatientDR,Config);
        return data
    }
    /**
     * @Author ʯ��ΰ
     * @desc M��ȡ���߸���ʷ������ϸ��Ϣ(���echartsͼ)
     * @param {*} id ����ʷid
     * @Last Modified by:   ʯ��ΰ   
     * @Last Modified time: 2020-04-20
     */
    function getPersonalInfoDetail(id){
	    //fwk
	    var DataInfo = "web.CDSS.PatientView.PersonalInfo[A]GetPersoInfoForForm[A]"+id;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.PatientView.PersonalInfo","GetPersoInfoForForm",id);
        return data;        
    }

    /**
     * @Author ������
     * @desc M��ȡ���߻�����Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @Last Modified time: 2020-04-20
     */
    function getPatientBaseInfo(IDNO,PatientDR,Config){
	    //fwk
	    var DataInfo = "web.CDSS.Public.PatientModel[A]GetPatientBaseInfo[A]"+IDNO+"[A]"+PatientDR+"[A]"+Config;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.Public.PatientModel","GetPatientBaseInfo",IDNO,PatientDR,Config);
        return data;        
    }
     /**
     * @Author ������
     * @desc M��ȡ���߾�����Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @Last Modified time: 2020-04-20
     */
    function getPatientVisitInfo(IDNO,PatientDR,Config){
	    //fwk
	    var DataInfo = "web.CDSS.Public.PatientModel[A]GetPatientVisitInfo[A]"+IDNO+"[A]"+PatientDR+"[A]"+VisitID+"[A]"+Config;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.Public.PatientModel","GetPatientVisitInfo",IDNO,PatientDR,VisitID,Config);
        return data;        
    }
    /**
    * @Author ʯ��ΰ
    * @desc M��ȡ���߻���ʷ��Ϣ(ʱ����ͼ)
    * @Last Modified by:   ʯ��ΰ   
    * @Last Modified time: 2020-04-21
    */
    function getMarryInfo(){
	    //fwk
	    /*var DataInfo = "web.DHCBL.MKB.MKBConfig[A]GetConfigValue[A]CDSSdyn20200416";
        var Config = CDSSMakeServerCall(DataInfo);*/
        //var Config= tkMakeServerCall("web.DHCBL.MKB.MKBConfig","GetConfigValue","CDSSdyn20200416");
        
        var DataInfo = "web.CDSS.PatientView.MarryInfo[A]GetMarryInfoForEcharts[A]"+IDNO+"[A]"+PatientDR+"[A]"+Config;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.PatientView.MarryInfo","GetMarryInfoForEcharts",IDNO,PatientDR,Config);
        return data
    }
        /**
     * @Author ʯ��ΰ
     * @desc M��ȡ���߻���ʷ������ϸ��Ϣ(���ʱ����ڵ�)
     * @param {*} id ����ʷid
     * @Last Modified by:   ʯ��ΰ   
     * @Last Modified time: 2020-04-21
     */
    function getMarryInfoDetail(id){
	    var DataInfo = "web.CDSS.PatientView.MarryInfo[A]GetMarryInfoForForm[A]"+id;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.PatientView.MarryInfo","GetMarryInfoForForm",id);
        return data;        
    }
    /**
    * @Author ʯ��ΰ
    * @desc M��ȡ���߼���ʷ��Ϣ(echartsͼ)
    * @Last Modified by:   ʯ��ΰ   
    * @Last Modified time: 2020-04-23
    */
    function getFamilyInfo(){
	    /*var DataInfo = "web.DHCBL.MKB.MKBConfig[A]GetConfigValue[A]CDSSdyn20200416";
        var Config = CDSSMakeServerCall(DataInfo);*/
        //var Config= tkMakeServerCall("web.DHCBL.MKB.MKBConfig","GetConfigValue","CDSSdyn20200416");
        
        var DataInfo = "web.CDSS.PatientView.FamilyHisInfo[A]GetFamilyHisInfoForEcharts[A]"+IDNO+"[A]"+PatientDR+"[A]"+Config;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.PatientView.FamilyHisInfo","GetFamilyHisInfoForEcharts",IDNO,PatientDR,Config);
        return data
    }
    /**
     * @Author ʯ��ΰ
     * @desc M��ȡ���߼���ʷ������ϸ��Ϣ(���echartsͼ)
     * @param {*} id ����ʷid��
     * @Last Modified by:   ʯ��ΰ   
     * @Last Modified time: 2020-04-23
     */
    function getFamilyInfoDetail(ids){
	    var DataInfo = "web.CDSS.PatientView.FamilyHisInfo[A]GetFamilyHisInfoForForm[A]"+ids;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.PatientView.FamilyHisInfo","GetFamilyHisInfoForForm",ids);
        return data;        
    }
    
    /**
        * @Author ʯ��ΰ
        * @desc M��ȡ��������ʱ������Ϣ(echartsͼ)
        * @Last Modified by:   ʯ��ΰ   
        * @Last Modified time: 2020-04-23
        */
    function getDiagInfo(){
        /*var DataInfo = "web.DHCBL.MKB.MKBConfig[A]GetConfigValue[A]CDSSdyn20200416";
        var Config = CDSSMakeServerCall(DataInfo);*/
        //var Config= tkMakeServerCall("web.DHCBL.MKB.MKBConfig","GetConfigValue","CDSSdyn20200416");
        var DataInfo = "web.CDSS.PatientView.DiagnosisInfo[A]GetDiagInfoForEcharts[A]"+IDNO+"[A]"+PatientDR+"[A]"+Config;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.PatientView.DiagnosisInfo","GetDiagInfoForEcharts",IDNO,PatientDR,Config);
        return data
    }
     /**
     * @Author ������
     * @desc M��ȡ����������Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-04-20
     */
    function getPatientSignInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetPatientSignInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ����������Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-04-29
     */
    function getPatienCompInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetPatienCompInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data="["+data+"]"
         data =JSON.parse(data)
        return data;        
    }
     /**
     * @Author ������
     * @desc M��ȡ�����ֲ�ʷ��Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-04-29
     */
    function getCurrentMedHistory(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetCurrentMedHistory",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data="["+data+"]"
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ʯ��ΰ
     * @desc M��ȡ2dͼչʾ��Ϣ����
     * @Last Modified by:   ʯ��ΰ   
     * @Last Modified time: 2020-04-23
     */
    function getInfoForPortrait() {
        var DataInfo = "web.CDSS.Public.PatientModelInterface[A]GetPatientEnumInfo[A]"+PatientUserInfo+"^֢״";
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.Public.PatientModelInterface", "GetPatientEnumInfo", PatientUserInfo+"^֢״");//"DH002^te002^1^^^^^^1^֢״");
        data = JSON.parse(data);
        var newdata = [];//���ű����ݵ�id��ͬ����ȥ��������ƴ��
        for(var i= 0; i < data.length; i++){
            newdata.push(
                {
                    'id':i,
                    'Part': data[i].Part,//��λ
                    'PartL':data[i].PartL,//������λ
                    'Symptom':data[i].Symptom,//֢״
                    //'Cause':data[i].Cause,//����
                    'AbnormalMax':data[i].AbnormalMax,//���ֵ
                    'AbnormalMin':data[i].AbnormalMin,//��Сֵ
                    'Duration':data[i].Duration,//����ʱ��
                    'RangeType':data[i].RangeType,//ֵ������
                    'RangeUnit':data[i].RangeUnit//ֵ��λ
                }
            )
        }
        return newdata;        
    }
    /**
     * @Author ������
     * @desc M��ȡ���߼���ʷ��Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-04-29
     */
    function getTablePastDiagnosis(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetPastDiagnosis",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
        }, false);
        data = JSON.parse(data);
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ���߸���ʷ��Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-07
     */
    function getTablePersonalInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetPersonalInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ���߻���ʷ��Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-07
     */
    function getTableMarryInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetMarryInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ���߼���ʷ��Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-07
     */
    function getTableFamilyHisInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetFamilyHisInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ���߹���ʷ��Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-07
     */
    function getTableAllergyHistory(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetAllergyHistory",
            IDNO: IDNO,
            PatientDR: PatientDR,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
     /**
     * @Author ������
     * @desc M��ȡ���߼����Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-09
     */
    function getPatientExamInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.PatientView.ExamInfo",
            MethodName: "GetPatientExamInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
     /**
     * @Author ������
     * @desc M��ȡ���߼�����Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-09
     */
    function getPatientLabInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.PatientView.LabInfo",
            MethodName: "GetPatientLabInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
     /**
     * @Author ������
     * @desc M��ȡ���߻�����Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-09
     */
    function getNursingInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.PatientView.NursingInfo",
            MethodName: "GetNursingInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ���Ŀ�
     * @desc ��ȡȷ��������ݣ��б�
     * @Last Modified by:   ���Ŀ�
     * @Last Modified time: 2020-05-09
     */
    function getConfirmDiag(){
        var PatentVar = PatientUserInfo + "^���";
        var DataInfo = "web.CDSS.Public.PatientModelInterface[A]GetPatientEnumInfo[A]"+PatentVar;
        var confirmarr = CDSSMakeServerCall(DataInfo);
        //var confirmarr = tkMakeServerCall("web.CDSS.Public.PatientModelInterface","GetPatientEnumInfo",PatentVar);
        //confirmarr = JSON.parse(confirmarr)
        confirmarr = eval('(' + confirmarr + ')');
        return confirmarr;
    }
    /**
     * @Author ������
     * @desc M��ȡ���������
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getPhysicalExam(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetPhysicalExam",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data ="["+data+"]" 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ����ר��
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getSpecExamInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetSpecExamInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data ="["+data+"]"
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ���������Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getDiagnosisInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetDiagnosisInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ���ߴ�����Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getPatientDrugInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetPatientDrugInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
     /**
     * @Author ������
     * @desc M��ȡ����������Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getOperationInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetOperationInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ����������Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getAnestInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetAnestInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ������Ѫ��Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getBloodTransInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetBloodTransInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ������ʳ��Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getPatientDietInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetPatientDietInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ��������ҽ����Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getOtherOrderInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetOtherOrderInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ���߳�Ժ��ҩ��Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getCarryDrugInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetCarryDrugInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ������
     * @desc M��ȡ���߳�Ժҽ����Ϣ
     * @param {*} IDNO ����������
     * @param {*} PatientDR ���˱�ʶ
     * @param {*} VisitID ���߾���������
     * @param {*} Config ������Ϣ
     * @Last Modified time: 2020-05-11
     */
    function getOtherDisOrderInfo(IDNO,PatientDR,Config){
        var data = $.m({
            ClassName: "web.CDSS.Public.PatientModel",
            MethodName: "GetOtherDisOrderInfo",
            IDNO: IDNO,
            PatientDR: PatientDR,
            VisitID: VisitID,
            Config: Config
         },false); 
         data =JSON.parse(data)
        return data;        
    }
    /**
     * @Author ʯ��ΰ
     * @desc ��ȡ����Ԥ���еļ���Ԥ���б���Ϣ
     * @Last Modified by:   ʯ��ΰ
     * @Last Modified time: 2020-05-15
    */
    function getDiagWarningData(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/DiseaseWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        })
    }
        /**
     * @Author ʯ��ΰ
     * @desc ��ȡ��ѪԤ���е���ѪԤ���б���Ϣ
     * @Last Modified by:   ʯ��ΰ
     * @Last Modified time: 2021-07-05
    */
    function getBloodWarningData(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/MetachysisWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        })
    }
    /**
     * @Author ���Ŀ�
     * @desc ��ȡҩ��Ԥ���е�ҩ��Ԥ���б���Ϣ
     * @Last Modified by:   ���Ŀ�
     * @Last Modified time: 2020-06-03
    */
    function getDrugWarningData(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/DrugWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        })
    }
    /**
     * @Author ���Ŀ�
     * @desc ��ȡ���Ԥ���еļ��Ԥ���б���Ϣ
     * @Last Modified by:   ���Ŀ�
     * @Last Modified time: 2020-06-03
    */
    function getInspectWarningData(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/InspectWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        })
    }
    /**
     * @Author ���Ŀ�
     * @desc ��ȡ����Ԥ���еļ���Ԥ���б���Ϣ
     * @Last Modified by:   ���Ŀ�
     * @Last Modified time: 2020-06-03
    */
    function getLabTestWarningData(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/LabTestWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        })
    }
    /**
     * @Author ʯ��ΰ
     * @desc ��ȡ����Ԥ���б���Ϣ
     * @Last Modified by:   ʯ��ΰ
     * @Last Modified time: 2020-07-20
    */
    function getNurseWarningData(){
        return new Promise(function(resolve,reject){//ʹ��promise�����ƿ���ʹ��return��������
            $.ajax({
                url:"http://"+InterfaceIP+"/NursingWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("��������ʧ�ܣ�");
                }
            });
        })
    }

    //�Ѻ������windowȫ�ֺ�����������ֹ����js�ڵ���ʱ��������ͬ����������
    window.getDiagWarningData = getDiagWarningData;
    window.getDrugWarningData = getDrugWarningData;
    window.getInspectWarningData = getInspectWarningData;
    window.getLabTestWarningData = getLabTestWarningData;
    window.getNurseWarningData = getNurseWarningData;
    window.getSuspectDiag = getSuspectDiag;
    window.getSuspectGrid = getSuspectGrid;
    window.getSymptoms = getSymptoms;
    window.getDiffDiag = getDiffDiag;
    window.getGradingOfDisease = getGradingOfDisease;
    window.getPastDiag = getPastDiag;
    window.GetPastDiagDetail = GetPastDiagDetail;
    window.getPersonalInfo = getPersonalInfo;
    window.getPersonalInfoDetail = getPersonalInfoDetail;
    window.getPatientBaseInfo = getPatientBaseInfo;
    window.getPatientVisitInfo = getPatientVisitInfo;
    window.getMarryInfo = getMarryInfo;
    window.getMarryInfoDetail = getMarryInfoDetail; 
    window.getFamilyInfo = getFamilyInfo;
    window.getFamilyInfoDetail = getFamilyInfoDetail;
    window.getDiagInfo = getDiagInfo;
    window.getPatientSignInfo = getPatientSignInfo;
    window.getPatienCompInfo = getPatienCompInfo;
    window.getCurrentMedHistory = getCurrentMedHistory;
    window.getInfoForPortrait = getInfoForPortrait;
    window.getTablePastDiagnosis = getTablePastDiagnosis;
    window.getTablePersonalInfo = getTablePersonalInfo;
    window.getTableMarryInfo = getTableMarryInfo;
    window.getTableFamilyHisInfo = getTableFamilyHisInfo;
    window.getTableAllergyHistory = getTableAllergyHistory;
    window.getRareDiag = getRareDiag;
    window.getAssistExamByDiag = getAssistExamByDiag;
    window.getAllAssistExam = getAllAssistExam;
    window.getPatientExamInfo = getPatientExamInfo;
    window.getPatientLabInfo = getPatientLabInfo;
    window.getNursingInfo = getNursingInfo;
    window.getConfirmDiag = getConfirmDiag;
    window.getPhysicalExam = getPhysicalExam;
    window.getSpecExamInfo = getSpecExamInfo;
    window.getDiagnosisInfo = getDiagnosisInfo;
    window.getPatientDrugInfo = getPatientDrugInfo;
    window.getOperationInfo = getOperationInfo;
    window.getAnestInfo = getAnestInfo;
    window.getBloodTransInfo = getBloodTransInfo;
    window.getPatientDietInfo = getPatientDietInfo;
    window.getOtherOrderInfo = getOtherOrderInfo;
    window.getCarryDrugInfo = getCarryDrugInfo;
    window.getOtherDisOrderInfo = getOtherDisOrderInfo;
	window.getBloodWarningData=getBloodWarningData 
})
