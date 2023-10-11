$(function(){ 
	
	initButton();			//初始化按钮

})
function initButton()
{
	$("#find").bind("click",TakCheck);			// 保存
}
function TakCheck()
{
	
		/**  
	     * 初始化创建PDSS对象 
	 */  
	 var pdss = new PDSS({});  
		/*var PdssObj = {  
	     "Action":"",   //  应用场景（CheckRule：用药审查,EduRule 用药指导,Cdss:cdss应用）
	     "MsgID":"",          //  监测日志id（回写数据用）
	     "PatName":"张三",        //  姓名  
	     "SexProp":"男",          // 性别  
	     "AgeProp":"1993-02-10", // 出生日期  
	     "Height":"170",         // 身高(厘米值)  
	     "Weight":"51",          // 体重(kg)   
	     "BillType":"医保",      // 费别 (医保,自费)  
	     "BloodPress":"",        // 血压  
	     "SpecGrps":["肾功能不全","孕妇"],  //特殊人群  
	     "ProfessProp":"运动员",    // 职业  
	     "PatType":"门诊",          // 患者类别(门诊,住院,急诊)  
	     "PatLoc":"消化内科",       // 就诊科室  
	     "MainDoc":"石亚飞",        // 主管医生  
	     "EpisodeID":"001",        // 就诊ID  
	     "ItemAyg":[               // 过敏记录  
        {  
	            "id":"itemAyg",   // 标识  
	            "item":"青霉素"    // 过敏项目  
	       }  
	    ],  
	    "ItemDis":[               // 疾病  
	        {  
	            "id":"itemDis",   // 标识  
	            "item":"肺炎"      // 疾病  
	        },  
	        {  
	            "id":"itemDis",  
	            "item":"中耳炎"  
	        }  
	    ],  
	    "ItemLab":[        // 检验  
	        {  
	            "id":"itemLab",   // 标识  
	            "item":"白细胞"   // 检验项目  
	        }  
	    ],  
	    "ItemLabDetail":[        // 检验项目明细 
	        {  
	            "Val":"10",       // 检验结果值  
	            "Unit":"mg",      // 检验结果值单位  
	            "id":"labDetail",   // 标识  
            "item":"白细胞"   // 检验项目  
	        }  
	    ],
	    "ItemOper":[        // 手术  
	        {     
	            "id":"itemOper",    // 标识  
	            "item":"颅部切合术"  // 手术名称  
	        }  
	    ],  
	    "ItemOrder":[         // 药品  
	        {  
	            "SeqNo":"1",                // 医嘱序号  
	            "PhDesc":"阿司匹林肠溶片",   // 药品名称  
	            "FormProp":"片剂",          // 剂型  
	            "OnceDose":"200",           // 单次剂量  
	            "Unit":"mg",                // 单次剂量单位  
	            "DrugPreMet":"口服",         // 用法  
	            "DrugFreq":"tid",           // 频次  
	            "Treatment":"1天",          // 疗程  
	            "id":"itemOrder",           // 标识  
	            "LinkSeqNo":"1",            // 关联序号(1, 1.1, 1.2)  
	            "OrdDate":"2020-03-06",     // 医嘱日期  
	            "IsFirstUseProp":"首次",    // 是否首次(首次/非首次)  
	            "DurgSpeedProp":"" ,         // 给药速度 
	            "DrugSpeedPropUnit":""		// 给药速度单位
	              
	        },  
	        {  
	            "SeqNo":"2",                  // 医嘱序号  
	            "PhDesc":"盐酸丙美卡因滴眼液",  // 药品名称  
	            "FormProp":"滴眼剂",           // 剂型  
             "OnceDose":"2",               // 单次剂量  
	            "Unit":"滴",                  // 单次剂量单位  
	            "DrugPreMet":"滴眼",          // 用法  
	            "DrugFreq":"每日4次",        // 频次  
	            "Treatment":"2天",           // 疗程  
	            "LinkSeqNo":"2.2",           // 关联序号(1, 1.1, 1.2)  
	            "id":"itemOrder",            // 标识  
	            "OrdDate":"2020-03-06",      // 医嘱日期  
	            "IsFirstUseProp":"首次",      // 是否首次(首次/非首次)  
	            "DurgSpeedProp":"1" ,           // 给药速度  
	 			        "DrugSpeedPropUnit":"滴/分"		// 给药速度单位
	        }     
	    ]  
		}  */
		/**  
	     * 调用审查接口 
	     * 参数说明： 
	     * 第一个参数：审核对象 
	     * 第二个参数：回调函数，回调函数未空时，传null即可 
	     * 第三个参数：审查方式，1 - 审查不通过时，弹出审查结果DIV；2 - 不弹窗 
 */ 
 	
 	var PdssObj =
 	{
					"Action": "CheckRule",
					"MsgID": "",
					"PatName": "住院2",
					"SexProp": "男",
					"AgeProp": "1996-01-01",
					"Height": "",
					"Weight": " ",
					"BillType": "全自费",
					"BloodPress": "120\\90",
					"SpecGrps": ["17", "26"],
					"ProfessProp": "",
					"PatType": "住院",
					"PatLoc": "内分泌科",
					"MainDoc": "医生01",
					"EpisodeID": "108",
					"ItemAyg": [],
					"ItemDis": [{
							 "id": "itemDis  ",
								"item": "唇炎"
					}, {
								"id": "itemDis",
								"item": "阿哥拉沙门菌肠炎"
					}],
					"ItemLab": [],
					"ItemLabDetail": [],
					"ItemOper": [],
					"ItemOrder": [{
								"SeqNo": "1",
								"PhDesc": "0.9%氯化钠注射液[500ml]",
								"FormProp": "大输液",
								"OnceDose": "500",
								"Unit": "ml",
								"DrugPreMet": "静脉滴注",
								"DrugFreq": "St",
								"Treatment": "1天",
								"id": "itemOrder",
								"LinkSeqNo": "",
								"OrdDate": "2020-09-09",
								"IsFirstUseProp": "非首次",
								"DurgSpeedProp": "",
								"DrugSpeedPropUnit": ""
					}],
					"ClientIP": "113.140.81.66"
				}
 	pdss.refresh(PdssObj, null, 1);  /// 调用审查接口
 	/** 
	     * pdss.passFlag  审查结果通过状态，0 - 不通过、1 - 通过:  
	     * pdss.manLevel  审核结果警示级别，正常、提醒、警示、禁止 
	 */  
	 if(pdss.passFlag == 0) {  
	         
	        /// do something  审查不通过时，执行代码
	        return;  
	   }  



}