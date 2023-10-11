/*
* @Author: 基础数据平台-石萧伟
* @Date:   2020-04-14
* @Last Modified by:   石萧伟
* @Last Modified time: 2020-04-14
* @描述:诊断决策功能模块后台调用python的ajax方法封装
*/
$(function () {
    /**
     * @Author 石萧伟
     * @desc ajax获取疑似诊断数据（树）
     * @Last Modified by:   石萧伟
     * @Last Modified time: 2020-04-14
     */
    function getSuspectDiag(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSuspectedDisease?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                //timeout : 1000, //超时时间设置，单位毫秒
                success: function(data){
	                console.log("http://"+InterfaceIP+"/GetSuspectedDisease?PatientUserInfo="+encodeURIComponent(PatientUserInfo))
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                },
//		    　　complete : function(XMLHttpRequest,status){ //请求完成后最终执行参数
//					if(status == "timeout"){
//						ajaxTimeOut.abort();
//						console.log("疑似疾病请求超时")
//					}
//		    　　}
            });
        })
    }
    /**
     * @Author 石萧伟
     * @desc ajax获取罕见病（树）
     * @Last Modified by:   石萧伟
     * @Last Modified time: 2020-04-14
     */
    function getRareDiag(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/GetRareDiseases?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        })
    }
    /**
     * @Author 石萧伟
     * @desc ajax获取疾病下检验检查
     * @Last Modified by:   石萧伟
     * @Last Modified time: 2020-04-14
     */
    function getAssistExamByDiag(diag){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSuspectedDisAssistExam?PatientUserInfo="+encodeURIComponent(PatientUserInfo)+"&Disease="+encodeURIComponent(diag),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        })
    }
    /**
     * @Author 石萧伟
     * @desc ajax获取所有的检验检查
     * @Last Modified by:   石萧伟
     * @Last Modified time: 2020-04-14
     */
    function getAllAssistExam(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSuspectedAllAssistExam?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        })
    }
    /**
     * @Author 石萧伟
     * @desc ajax获取疑似诊断数据（列表）
     * @Last Modified by:   石萧伟
     * @Last Modified time: 2020-04-14
     */
    function getSuspectGrid(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSuspectedDiseaseList?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){    
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        });
    }
    /**
     * @Author 石萧伟
     * @desc ajax获取诊断下的症状数据
     * @Last Modified by:   石萧伟
     * @param {*} diag 诊断名称    
     * @Last Modified time: 2020-04-14
    */
    function getSymptoms(diag){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/GetSelectedSymptoms?Disease="+encodeURIComponent(diag)+"&PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        });
    

    }
    /**
     * @Author 石萧伟
     * @desc ajax获取诊断下的鉴别诊断数据
     * @Last Modified by:   石萧伟
     * @param {*} diag 诊断名称    
     * @Last Modified time: 2020-04-14
    */
    function getDiffDiag(diag){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/GetDiffDisease?PatientUserInfo="+encodeURIComponent(PatientUserInfo)+"&Disease="+encodeURIComponent(diag),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        });
    }
    /**
     * @Author 石萧伟
     * @desc ajax获取病人病情分级
     * @Last Modified by:   石萧伟   
     * @Last Modified time: 2020-04-14
    */
    function getGradingOfDisease() {
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/recom_emerstand?patient_info="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function(data){
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        });

    }

   /**
    * @Author 石萧伟
    * @desc M获取患者既往史信息(echarts图)
    * @Last Modified by:   石萧伟   
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
     * @Author 石萧伟
     * @desc M获取患者既往史单条详细信息(点击echarts图)
     * @param {*} id 既往史id
     * @Last Modified by:   石萧伟   
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
    * @Author 石萧伟
    * @desc M获取患者个人史信息(echarts图)
    * @Last Modified by:   石萧伟   
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
     * @Author 石萧伟
     * @desc M获取患者个人史单条详细信息(点击echarts图)
     * @param {*} id 个人史id
     * @Last Modified by:   石萧伟   
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
     * @Author 丁亚男
     * @desc M获取患者基础信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
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
     * @Author 丁亚男
     * @desc M获取患者就诊信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
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
    * @Author 石萧伟
    * @desc M获取患者婚育史信息(时间轴图)
    * @Last Modified by:   石萧伟   
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
     * @Author 石萧伟
     * @desc M获取患者婚育史单条详细信息(点击时间轴节点)
     * @param {*} id 婚育史id
     * @Last Modified by:   石萧伟   
     * @Last Modified time: 2020-04-21
     */
    function getMarryInfoDetail(id){
	    var DataInfo = "web.CDSS.PatientView.MarryInfo[A]GetMarryInfoForForm[A]"+id;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.PatientView.MarryInfo","GetMarryInfoForForm",id);
        return data;        
    }
    /**
    * @Author 石萧伟
    * @desc M获取患者家族史信息(echarts图)
    * @Last Modified by:   石萧伟   
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
     * @Author 石萧伟
     * @desc M获取患者家族史单条详细信息(点击echarts图)
     * @param {*} id 家族史id串
     * @Last Modified by:   石萧伟   
     * @Last Modified time: 2020-04-23
     */
    function getFamilyInfoDetail(ids){
	    var DataInfo = "web.CDSS.PatientView.FamilyHisInfo[A]GetFamilyHisInfoForForm[A]"+ids;
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.PatientView.FamilyHisInfo","GetFamilyHisInfoForForm",ids);
        return data;        
    }
    
    /**
        * @Author 石萧伟
        * @desc M获取患者诊疗时间轴信息(echarts图)
        * @Last Modified by:   石萧伟   
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
     * @Author 丁亚男
     * @desc M获取患者体征信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者主诉信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者现病史信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 石萧伟
     * @desc M获取2d图展示信息数据
     * @Last Modified by:   石萧伟   
     * @Last Modified time: 2020-04-23
     */
    function getInfoForPortrait() {
        var DataInfo = "web.CDSS.Public.PatientModelInterface[A]GetPatientEnumInfo[A]"+PatientUserInfo+"^症状";
        var data = CDSSMakeServerCall(DataInfo);
        //var data = tkMakeServerCall("web.CDSS.Public.PatientModelInterface", "GetPatientEnumInfo", PatientUserInfo+"^症状");//"DH002^te002^1^^^^^^1^症状");
        data = JSON.parse(data);
        var newdata = [];//四张表数据的id不同，需去除掉重新拼串
        for(var i= 0; i < data.length; i++){
            newdata.push(
                {
                    'id':i,
                    'Part': data[i].Part,//部位
                    'PartL':data[i].PartL,//顶级部位
                    'Symptom':data[i].Symptom,//症状
                    //'Cause':data[i].Cause,//病因
                    'AbnormalMax':data[i].AbnormalMax,//最大值
                    'AbnormalMin':data[i].AbnormalMin,//最小值
                    'Duration':data[i].Duration,//持续时长
                    'RangeType':data[i].RangeType,//值域类型
                    'RangeUnit':data[i].RangeUnit//值域单位
                }
            )
        }
        return newdata;        
    }
    /**
     * @Author 丁亚男
     * @desc M获取患者既往史信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者个人史信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者婚育史信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者家族史信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者过敏史信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者检查信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者检验信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者护理信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 范文凯
     * @desc 获取确诊诊断数据（列表）
     * @Last Modified by:   范文凯
     * @Last Modified time: 2020-05-09
     */
    function getConfirmDiag(){
        var PatentVar = PatientUserInfo + "^诊断";
        var DataInfo = "web.CDSS.Public.PatientModelInterface[A]GetPatientEnumInfo[A]"+PatentVar;
        var confirmarr = CDSSMakeServerCall(DataInfo);
        //var confirmarr = tkMakeServerCall("web.CDSS.Public.PatientModelInterface","GetPatientEnumInfo",PatentVar);
        //confirmarr = JSON.parse(confirmarr)
        confirmarr = eval('(' + confirmarr + ')');
        return confirmarr;
    }
    /**
     * @Author 丁亚男
     * @desc M获取患者体格检查
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者专科
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者诊断信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者处方信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者手术信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者麻醉信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者输血信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者饮食信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者其他医嘱信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者出院带药信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 丁亚男
     * @desc M获取患者出院医嘱信息
     * @param {*} IDNO 患者主索引
     * @param {*} PatientDR 病人标识
     * @param {*} VisitID 患者就诊次数编号
     * @param {*} Config 配置信息
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
     * @Author 石萧伟
     * @desc 获取疾病预警中的疾病预警列表信息
     * @Last Modified by:   石萧伟
     * @Last Modified time: 2020-05-15
    */
    function getDiagWarningData(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/DiseaseWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        })
    }
        /**
     * @Author 石萧伟
     * @desc 获取输血预警中的输血预警列表信息
     * @Last Modified by:   石萧伟
     * @Last Modified time: 2021-07-05
    */
    function getBloodWarningData(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/MetachysisWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        })
    }
    /**
     * @Author 范文凯
     * @desc 获取药物预警中的药物预警列表信息
     * @Last Modified by:   范文凯
     * @Last Modified time: 2020-06-03
    */
    function getDrugWarningData(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/DrugWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        })
    }
    /**
     * @Author 范文凯
     * @desc 获取检查预警中的检查预警列表信息
     * @Last Modified by:   范文凯
     * @Last Modified time: 2020-06-03
    */
    function getInspectWarningData(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/InspectWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        })
    }
    /**
     * @Author 范文凯
     * @desc 获取检验预警中的检验预警列表信息
     * @Last Modified by:   范文凯
     * @Last Modified time: 2020-06-03
    */
    function getLabTestWarningData(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/LabTestWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        })
    }
    /**
     * @Author 石萧伟
     * @desc 获取护理预警列表信息
     * @Last Modified by:   石萧伟
     * @Last Modified time: 2020-07-20
    */
    function getNurseWarningData(){
        return new Promise(function(resolve,reject){//使用promise来控制可以使用return返回数据
            $.ajax({
                url:"http://"+InterfaceIP+"/NursingWarning?PatientUserInfo="+encodeURIComponent(PatientUserInfo),
                type: "GET",
                dataType: "json",
                cache: false,
                success: function (data) {
                    resolve(data);
                },
                error:function(){
                    reject("请求数据失败！");
                }
            });
        })
    }

    //把函数变成window全局函数变量，防止其它js在调用时，含有相同方法被覆盖
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
