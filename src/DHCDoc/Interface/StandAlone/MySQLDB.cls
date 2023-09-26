/// Creator：zhouc
/// CreatDate：2022-10-19
/// Description: 收费应急系统医生站-DB
Class DHCDoc.Interface.StandAlone.MySQLDB Extends Base
{

/***
  **Description      :判断表是否在数据库中存在
  **Author           :zhouc
  **Time             :2022/10/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.MySQLDB).IsTableExist("DHC_UserFavItems")
  **Parameter        : his 表名
  **Returns          :
***/
ClassMethod IsTableExist(tableName)
{
    s IsExist=0
    &SQL(select count(TABLE_NAME) into :IsExist from INFORMATION_SCHEMA.TABLES where TABLE_NAME=:tableName )
    q:IsExist>0 "1"
    q "0"
}

/***
  **Description      :重建表SQL
  **Author           :zhouc
  **Time             :2022/10/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.MySQLDB).DocTableSql()
  **Parameter        : his 表名
  **Returns          :
***/
ClassMethod DocTableSql(tNames = "")
{
    s CreateTableSql=""
    //挂号职称字典表
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `RBC_SessionType` ("
    s sql=sql_"`SESS_RowId` BIGINT NOT NULL AUTO_INCREMENT,"
    s sql=sql_"`SESS_Code` VARCHAR ( 255 ) NOT NULL COMMENT 'Code',"
    s sql=sql_"`SESS_Desc` VARCHAR ( 255 ) NOT NULL COMMENT 'Description',"
    s sql=sql_"`SESS_SessionType_DR` BIGINT DEFAULT NULL COMMENT 'Des Ref Session Type',"
    s sql=sql_"`SESS_NumberOfDays` DOUBLE DEFAULT NULL COMMENT 'Number Of Days',"
    s sql=sql_"`SESS_EnableByDefault` VARCHAR ( 3 ) DEFAULT NULL COMMENT 'Enable By Default',"
    s sql=sql_"`SESS_DateFrom` date DEFAULT NULL COMMENT 'Date From',"
    s sql=sql_"`SESS_DateTo` date DEFAULT NULL COMMENT 'Date To',"
    s sql=sql_"`SESS_ReleaseDays` DOUBLE DEFAULT NULL COMMENT 'ReleaseDays',"
    s sql=sql_"`SESS_ConvertPeriod` DOUBLE DEFAULT NULL COMMENT 'ConvertPeriod(mins)',"
    s sql=sql_"`SESS_GenFrequency` DOUBLE DEFAULT NULL COMMENT 'GenFrequency',"
    s sql=sql_"`SESS_GenPeriod` VARCHAR ( 5 ) DEFAULT NULL COMMENT 'GenPeriod',"
    s sql=sql_"`SESS_Category` VARCHAR ( 50 ) DEFAULT NULL COMMENT '归类 （普通Normal、专家Specialist、主任Director、副主任DeputyDirector、急诊Emergency）',"
    s sql=sql_"PRIMARY KEY ( `SESS_RowId` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `DataMaster` ( `SESS_RowId` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexCode` ( `SESS_Code`, `SESS_RowId` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexDesc` ( `SESS_Desc`, `SESS_RowId` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //挂号职称费用表
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `DHC_RBCSessionTypeService` ("
    s sql=sql_"`SER_RowId` VARCHAR ( 69 ) NOT NULL,"
    s sql=sql_"`SER_Childsub` DOUBLE NOT NULL COMMENT 'Childsub',"
    s sql=sql_"`SER_ARCIM_DR` VARCHAR ( 36 ) DEFAULT NULL COMMENT 'Des Ref RBC_Service',"
    s sql=sql_"`SER_EXCludeAdmReason` LONGTEXT DEFAULT NULL COMMENT 'RBC_SessionType Parent Reference',"
    s sql=sql_"`SER_Hosp_DR` BIGINT DEFAULT NULL COMMENT '院区关联',"
    s sql=sql_"`SER_Type` VARCHAR ( 50 ) DEFAULT NULL COMMENT '挂号职称对应预开类型(正常医嘱OrderNorm,预开医嘱OrderPre,预开诊断OrderDiag)',"
    s sql=sql_"`SER_DiagnoseDr` BIGINT DEFAULT NULL COMMENT '预开诊断',"
    s sql=sql_"`SER_ParRef` VARCHAR ( 50 ) NOT NULL COMMENT 'RBC_SessionType Parent Reference',"
    s sql=sql_"PRIMARY KEY ( `SER_Childsub`, `SER_ParRef` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `DataMaster` ( `SER_ParRef`, `SER_Childsub` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //科室医生号别对照
	s sql="CREATE TABLE IF NOT EXISTS `dhcmarkdoc` ("
	s sql=sql_"`ID` bigint(20) NOT NULL,"
	s sql=sql_"`MarkdDocDr` varchar(255) DEFAULT NULL,"
	s sql=sql_"`MarkdMarkDr` varchar(255) DEFAULT NULL,"
	s sql=sql_"`Markddefault` varchar(50) DEFAULT NULL,"
	s sql=sql_"`MarkddepDr` bigint(20) DEFAULT NULL,"
	s sql=sql_"`SessionTypeDr` varchar(255) DEFAULT NULL COMMENT '默认的挂号职称',"
	s sql=sql_"PRIMARY KEY (`ID`) USING BTREE,"
	s sql=sql_"UNIQUE KEY `IDKEY` (`ID`) USING BTREE,"
	s sql=sql_"KEY `MarkdDocMarkIndex` (`MarkdDocDr`,`MarkdMarkDr`) USING BTREE,"
	s sql=sql_"KEY `MarkddepDrIndex` (`MarkddepDr`) USING BTREE"
	s sql=sql_") ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //检验外部代码关联表
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `ARC_ItemExternalCodes` ("
    s sql=sql_"`EXT_ParRef` VARCHAR ( 36 ) NOT NULL COMMENT 'ARC_ItmMast Parent Reference',"
    s sql=sql_"`EXT_RowId` LONGTEXT NOT NULL,"
    s sql=sql_"`EXT_Childsub` DOUBLE NOT NULL COMMENT 'Childsub',"
    s sql=sql_"`EXT_DateFrom` date NOT NULL COMMENT 'Date From',"
    s sql=sql_"`EXT_DateTo` date DEFAULT NULL COMMENT 'Date To',"
    s sql=sql_"`EXT_InsType_DR` BIGINT DEFAULT NULL COMMENT 'Des Ref InsType',"
    s sql=sql_"`EXT_Code` VARCHAR ( 64 ) NOT NULL COMMENT 'Code',"
    s sql=sql_"`EXT_AuxInsType_DR` BIGINT DEFAULT NULL COMMENT 'Des Ref AuxInsType',"
    s sql=sql_"`EXT_Desc` VARCHAR ( 220 ) DEFAULT NULL COMMENT 'Description',"
    s sql=sql_"`EXT_BillSub_DR` VARCHAR ( 38 ) DEFAULT NULL COMMENT 'Des Ref Bill Sub',"
    s sql=sql_"`EXT_CTLOC_DR` BIGINT DEFAULT NULL COMMENT 'Des Ref CTLOC_DR',"
    s sql=sql_"`EXT_DEfaultSend` VARCHAR ( 3 ) DEFAULT NULL COMMENT 'Default Send',"
    s sql=sql_"`EXT_DefaultReceive` VARCHAR ( 3 ) DEFAULT NULL COMMENT 'Default Receive',"
    s sql=sql_"`EXT_HL7SendingApp` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'HL7SendingApp',"
    s sql=sql_"`EXT_HL7SendingFacility` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'HL7SendingFacility',"
    s sql=sql_"PRIMARY KEY ( `EXT_Childsub`, `EXT_ParRef` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `DataMaster` ( `EXT_ParRef`, `EXT_Childsub` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexExtCode` ( `EXT_Code`, `EXT_ParRef`, `EXT_Childsub` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //检验外部数据信息
	s sql="CREATE TABLE IF NOT EXISTS `arc_itemexternalinfo` ("
	s sql=sql_"`ID` int(11) NOT NULL COMMENT '无意义，仅作为表记录',"
	s sql=sql_"`ExtCode` varchar(255) NOT NULL COMMENT '外部代码',"
	s sql=sql_"`SpecimenCode` varchar(255) NOT NULL COMMENT '标本代码',"
	s sql=sql_"`Specimen` varchar(255) NOT NULL COMMENT '标本描述',"
	s sql=sql_"`ContainerCode` varchar(255) DEFAULT NULL COMMENT '管代码',"
	s sql=sql_"`ContainerDesc` varchar(255) DEFAULT NULL COMMENT '管描述',"
	s sql=sql_"`TestsGroupCode` varchar(255) DEFAULT NULL COMMENT '检验分组标识，主要用来分管',"
	s sql=sql_"`HospitalCode` varchar(255) DEFAULT NULL COMMENT '院区代码',"
	s sql=sql_"`IsDefault` varchar(10) DEFAULT NULL COMMENT '是否默认',"
	s sql=sql_"PRIMARY KEY (`ID`) USING BTREE,"
	s sql=sql_"KEY `IndexExtCode` (`HospitalCode`,`ExtCode`,`ID`) USING BTREE,"
	s sql=sql_"KEY `MasterData` (`ID`) USING BTREE"
	s sql=sql_") ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //插件配置
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `dhc_websysaddins` ("
    s sql=sql_"`ID` BIGINT NOT NULL AUTO_INCREMENT,"
    s sql=sql_"`Active` VARCHAR ( 50 ) DEFAULT NULL COMMENT '是否激活 Y/N',"
    s sql=sql_"`Ass` VARCHAR ( 50 ) DEFAULT NULL COMMENT '程序集名--- Interop.PrjSetTime',"
    s sql=sql_"`AssDir` VARCHAR ( 50 ) DEFAULT NULL COMMENT '路径---http://127.0.0.1/dthealth/web/addins/ass/',"
    s sql=sql_"`ClassId` VARCHAR ( 50 ) DEFAULT NULL COMMENT 'classid的值 CLSID:F30DC1D4-5E29-4B89-902F-2E3DC81AE46D',"
    s sql=sql_"`ClientIPExp` LONGTEXT DEFAULT NULL COMMENT '需要升级的客户端IP表达式',"
    s sql=sql_"`Cls` VARCHAR ( 200 ) DEFAULT NULL COMMENT '类名----PrjSetTime.CLSSETTIMEClass',"
    s sql=sql_"`Code` VARCHAR ( 50 ) DEFAULT NULL COMMENT '生成控件的JS类名',"
    s sql=sql_"`DomId` VARCHAR ( 50 ) DEFAULT NULL COMMENT 'id名 ClsBillPrint',"
    s sql=sql_"`IsVis` VARCHAR ( 50 ) DEFAULT NULL COMMENT '是否可见',"
    s sql=sql_"`Mths` LONGTEXT DEFAULT NULL COMMENT '方法名集合',"
    s sql=sql_"`Note` VARCHAR ( 50 ) DEFAULT NULL COMMENT '功能说明',"
    s sql=sql_"`Props` LONGTEXT DEFAULT NULL COMMENT '属性名集合',"
    s sql=sql_"`SubPath` LONGTEXT DEFAULT NULL COMMENT '当前dll的子目录--lodop',"
    s sql=sql_"`Version` VARCHAR ( 50 ) DEFAULT NULL COMMENT 'DLL包版本',"
    s sql=sql_"PRIMARY KEY ( `ID` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `CodeInd` ( `Code` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IDKEY` ( `ID` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //读卡设备
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `DHC_CardHardComManager` ("
    s sql=sql_"`CCM_RowID` BIGINT NOT NULL AUTO_INCREMENT,"
    s sql=sql_"`CCM_Code` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CCM_Code',"
    s sql=sql_"`CCM_Desc` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CCM_Desc',"
    s sql=sql_"`CCM_ComGroup_DR` BIGINT DEFAULT NULL COMMENT 'CCM_ComGroup_DR',"
    s sql=sql_"`CCM_CLASSID` VARCHAR ( 50 ) DEFAULT NULL COMMENT 'CCM_CLASSID',"
    s sql=sql_"`CCM_OBJECTID` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CCM_OBJECTID',"
    s sql=sql_"`CCM_Version` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CCM_Version',"
    s sql=sql_"`CCM_CodeBase` VARCHAR ( 80 ) DEFAULT NULL COMMENT 'CCM_CodeBase',"
    s sql=sql_"`CCM_EquipPort` VARCHAR ( 4 ) DEFAULT NULL COMMENT 'CCM_EquipPort',"
    s sql=sql_"`CCM_JSFunctionName` VARCHAR ( 50 ) DEFAULT NULL COMMENT 'CCM_JSFunctionName',"
    s sql=sql_"`CCM_DLLFunctionName` VARCHAR ( 50 ) DEFAULT NULL COMMENT 'CCM_DLLFunctionName',"
    s sql=sql_"`CCM_DLLInPara1` VARCHAR ( 60 ) DEFAULT NULL COMMENT 'CCM_DLLInPara1',"
    s sql=sql_"`CCM_DLLInPara2` VARCHAR ( 60 ) DEFAULT NULL COMMENT 'CCM_DLLInPara2',"
    s sql=sql_"`CCM_DLLInPara3` VARCHAR ( 60 ) DEFAULT NULL COMMENT 'CCM_DLLInPara3',"
    s sql=sql_"`CCM_DateFrom` date DEFAULT NULL COMMENT 'CCM_DateFrom',"
    s sql=sql_"`CCM_DateTo` date DEFAULT NULL COMMENT 'CCM_DateTo',"
    s sql=sql_"`CCM_DLLType` VARCHAR ( 13 ) DEFAULT NULL COMMENT 'CCM_DLLType',"
    s sql=sql_"`CCM_Note2` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CCM_Note2',"
    s sql=sql_"`CCM_Note3` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CCM_Note3',"
    s sql=sql_"`CCM_Note4` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CCM_Note4',"
    s sql=sql_"`CCM_Note5` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CCM_Note5',"
    s sql=sql_"PRIMARY KEY ( `CCM_RowID` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `DataMaster` ( `CCM_RowID` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //读卡方法
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `DHC_CardHardDLLFunction` ("
    s sql=sql_"`CDF_CCM_ParRef` BIGINT NOT NULL COMMENT 'DHC_CardHardComManager Parent Reference',"
    s sql=sql_"`CDF_RowID` VARCHAR ( 38 ) NOT NULL,"
    s sql=sql_"`CDF_Sub` DOUBLE NOT NULL COMMENT 'CDF_Sub',"
    s sql=sql_"`CDF_DLLFunctionName` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CDF_DLLFunctionName',"
    s sql=sql_"`CDF_DLLInPara1` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CDF_DLLInPara1',"
    s sql=sql_"`CDF_DLLInPara2` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CDF_DLLInPara2',"
    s sql=sql_"`CDF_DLLInPara3` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CDF_DLLInPara3',"
    s sql=sql_"`CDF_DLLFunctionType` VARCHAR ( 5 ) DEFAULT NULL COMMENT 'CDF_DLLFunctionType',"
    s sql=sql_"`CDF_Note1` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CDF_Note1',"
    s sql=sql_"`CDF_Note2` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CDF_Note2',"
    s sql=sql_"`CDF_Note3` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CDF_Note3',"
    s sql=sql_"`CDF_Note4` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CDF_Note4',"
    s sql=sql_"`CDF_Note5` VARCHAR ( 30 ) DEFAULT NULL COMMENT 'CDF_Note5',"
    s sql=sql_"PRIMARY KEY ( `CDF_CCM_ParRef`, `CDF_Sub` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `DataMaster` ( `CDF_CCM_ParRef`, `CDF_Sub` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //医嘱模板大类
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `ARC_OrdFavCat` ("
    s sql=sql_"`ID` BIGINT NOT NULL AUTO_INCREMENT,"
    s sql=sql_"`Type` VARCHAR ( 50 ) NOT NULL COMMENT '类型 科室User.CTLoc,用户 User.SSUser|WNewOrderEntry|O、User.SSUser|WNewOrderEntry|I',"
    s sql=sql_"`TypeValue` VARCHAR ( 50 ) NOT NULL COMMENT '类型对应的值',"
    s sql=sql_"`Name` VARCHAR ( 50 ) NOT NULL COMMENT '大类名称',"
    s sql=sql_"`Sequece` INTEGER DEFAULT NULL COMMENT '显示顺序',"
    s sql=sql_"`UserAddDR` BIGINT DEFAULT NULL COMMENT '增加用户',"
    s sql=sql_"PRIMARY KEY ( `ID` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IDKEY` ( `ID` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexName` ( `Type`, `TypeValue`, `Name` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexSequece` ( `Type`, `TypeValue`, `Sequece` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //医嘱模板子类
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `ARC_OrdFavSubCat` ("
    s sql=sql_"`ID` BIGINT NOT NULL AUTO_INCREMENT,"
    s sql=sql_"`CatDR` BIGINT NOT NULL COMMENT '指向大类',"
    s sql=sql_"`Name` VARCHAR ( 50 ) NOT NULL COMMENT '子类名称',"
    s sql=sql_"`Sequece` INTEGER DEFAULT NULL COMMENT '显示顺序',"
    s sql=sql_"`UserAddDR` BIGINT DEFAULT NULL COMMENT '增加用户',"
    s sql=sql_"PRIMARY KEY ( `ID` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IDKEY` ( `ID` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexName` ( `CatDR`, `Name` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexSequece` ( `CatDR`, `Sequece` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //医嘱模板项目
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `ARC_OrdFavItem` ("
    s sql=sql_"`ID` BIGINT NOT NULL AUTO_INCREMENT,"
    s sql=sql_"`SubCatDR` BIGINT NOT NULL COMMENT '指向子类',"
    s sql=sql_"`ItemID` VARCHAR ( 50 ) NOT NULL COMMENT '项目ID(医嘱或医嘱套ID)',"
    s sql=sql_"`Sequece` INTEGER DEFAULT NULL COMMENT '显示顺序',"
    s sql=sql_"`UserAddDR` BIGINT DEFAULT NULL COMMENT '增加用户',"
    s sql=sql_"`Note` VARCHAR ( 50 ) DEFAULT NULL COMMENT '项目备注',"
    s sql=sql_"`PartInfo` VARCHAR ( 50 ) DEFAULT NULL COMMENT '检查部位信息',"
    s sql=sql_"PRIMARY KEY ( `ID` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IDKEY` ( `ID` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexItem` ( `SubCatDR`, `ItemID`, `PartInfo` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexSequece` ( `SubCatDR`, `Sequece` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //医嘱套类别
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `DHC_UserFavItems` ("
    s sql=sql_"`Fav_RowId` BIGINT NOT NULL AUTO_INCREMENT,"
    s sql=sql_"`Fav_Type` VARCHAR ( 50 ) NOT NULL,"
    s sql=sql_"`Fav_User_Dr` BIGINT DEFAULT NULL,"
    s sql=sql_"`Fav_ItemRowid` VARCHAR ( 50 ) NOT NULL,"
    s sql=sql_"`Fav_Dep_Dr` BIGINT DEFAULT NULL,"
    s sql=sql_"`Fav_Other` VARCHAR ( 50 ) DEFAULT NULL COMMENT '其他,可以通过控制类型来存储相应的其他的非用户和科室的关联',"
    s sql=sql_"`Fav_ContralType` VARCHAR ( 50 ) DEFAULT NULL,"
    s sql=sql_"`Fav_MedUnit_Dr` VARCHAR ( 50 ) DEFAULT NULL,"
    s sql=sql_"`Fav_Hosp_Dr` BIGINT DEFAULT NULL,"
    s sql=sql_"`Fav_CelerType` VARCHAR ( 50 ) DEFAULT NULL,"
    s sql=sql_"`Fav_UseHosp_Dr` BIGINT DEFAULT NULL,"
    s sql=sql_"`Fav_DateFrom` date DEFAULT NULL COMMENT '开始日期',"
    s sql=sql_"`Fav_DateTo` date DEFAULT NULL COMMENT '截至日期',"
    s sql=sql_"PRIMARY KEY ( `Fav_RowId` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `DataMaster` ( `Fav_RowId` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `IndexItemRowid` ( `Fav_ItemRowid`, `Fav_RowId` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql

    //医嘱套院区
    s sql=""
    s sql=sql_"CREATE TABLE IF NOT EXISTS `ARC_OrdSetsHosp` ("
    s sql=sql_"`HOSP_ParRef` VARCHAR ( 50 ) NOT NULL COMMENT 'ARC_OrdSets Parent Reference',"
    s sql=sql_"`HOSP_RowId` LONGTEXT NOT NULL,"
    s sql=sql_"`HOSP_Childsub` DOUBLE NOT NULL COMMENT 'Childsub',"
    s sql=sql_"`HOSP_Hospital_DR` BIGINT DEFAULT NULL COMMENT 'Des Ref Hospital',"
    s sql=sql_"PRIMARY KEY ( `HOSP_Childsub`, `HOSP_ParRef` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `Datamaster` ( `HOSP_ParRef`, `HOSP_Childsub` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql
    //医嘱套明细中的医嘱套
    s sql=""
    s sql=sql_"DROP TABLE IF EXISTS ARC_OrdSetDateOS;"
    s sql=sql_"CREATE TABLE `ARC_OrdSetDateOS` ("
    s sql=sql_"`OS_ParRef` varchar(254) NOT NULL COMMENT 'ARC_OrdSetDate Parent Reference',"
    s sql=sql_"`OS_RowId` varchar(254) NOT NULL,"
    s sql=sql_"`OS_Childsub` DOUBLE NOT NULL COMMENT 'Childsub',"
    s sql=sql_"`OS_OrderSet_DR` VARCHAR ( 50 ) DEFAULT NULL COMMENT 'Des Ref to ARCOS',"
    s sql=sql_"`OS_Price` DOUBLE DEFAULT NULL COMMENT 'Price',"
    s sql=sql_"`OS_SerialNo` DOUBLE DEFAULT NULL COMMENT 'Itemserialnumber序列码用于输出',"
    s sql=sql_"PRIMARY KEY ( `OS_Childsub`, `OS_ParRef` ) USING BTREE,"
    s sql=sql_"UNIQUE KEY `DataMaster` ( `OS_ParRef`, `OS_Childsub` ) USING BTREE "
    s sql=sql_") ENGINE = INNODB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;"
    s CreateTableSql=CreateTableSql_sql
	
    //排班数据
    s sql=""
    s sql=sql_"drop table if exists RB_ApptSchedule;"
    s sql=sql_"create table `RB_ApptSchedule` ("
    s sql=sql_"`AS_RES_ParRef` varchar(255) not null COMMENT 'RB_Resource Parent Reference',"
    s sql=sql_"`AS_RowId` longtext not null ,"
    s sql=sql_"`AS_ChildSub` double not null COMMENT 'Child Sub (New Key)',"
    s sql=sql_"`AS_Date` date not null COMMENT 'Appointment Date',"
    s sql=sql_"`AS_Session` varchar(4) not null COMMENT 'Session',"
    s sql=sql_"`AS_SessStartTime` time not null COMMENT 'Session Start Time',"
    s sql=sql_"`AS_SessEndTime` time not null COMMENT 'Session End Time',"
    s sql=sql_"`AS_NoApptSession` double not null COMMENT 'No Appt per session , MINVAL = 0',"
    s sql=sql_"`AS_Load` double not null COMMENT 'Load Level ',"
    s sql=sql_"`AS_Availability` double default null COMMENT 'Availability (0-empty load, 1-full load)',"
    s sql=sql_"`AS_NumPatIn` double not null default 0 COMMENT 'Number of patient came in',"
    s sql=sql_"`AS_NumPatOut` double not null default 0 COMMENT 'Number of patient complete visit',"
    s sql=sql_"`AS_Remarks` longtext default null COMMENT 'Remarks',"
    s sql=sql_"`AS_Slot` varchar(4) default null COMMENT 'Appointment Slot',"
    s sql=sql_"`AS_QueueNoCount` varchar(6) default null COMMENT 'Queue Number start count',"
    s sql=sql_"`AS_BookedSlots` double default null COMMENT 'Number of slots booked/arrived/complete',"
    s sql=sql_"`AS_RBEffDateSession_DR` longtext default null COMMENT 'Des Ref RBEffDateSession',"
    s sql=sql_"`AS_IrregularFlag` varchar(11) default null COMMENT 'IrregularFlag',"
    s sql=sql_"`AS_SessionType_DR` bigint default null COMMENT 'Des Ref SessionType',"
    s sql=sql_"`DHC_AS_SessionType_DR` bigint default null COMMENT 'Des Ref SessionType',"
    s sql=sql_"`AS_ActualDate` date default null COMMENT 'Actual session date',"
    s sql=sql_"`AS_ActualStartTime` time default null COMMENT 'Actual session start time',"
    s sql=sql_"`AS_ActualEndTime` time default null COMMENT 'Actual session end time',"
    s sql=sql_"`AS_ReasonForDelay_DR` bigint default null COMMENT 'Des ref RBC_ReasonForVariance',"
    s sql=sql_"`AS_ReasonForOvertime_DR` bigint default null COMMENT 'DR RBC_ReasonForVariance',"
    s sql=sql_"`AS_GenerationDate` date default null COMMENT 'GenerationDate',"
    s sql=sql_"`AS_GenerationTime` time default null COMMENT 'GenerationTime',"
    s sql=sql_"`AS_LastUpdateUser_DR` bigint default null COMMENT 'Des Ref LastUpdateUser',"
    s sql=sql_"`AS_LastUpdateDate` date default null COMMENT 'LastUpdateDate',"
    s sql=sql_"`AS_LastUpdateTime` time default null COMMENT 'LastUpdateTime',"
    s sql=sql_"`AS_NotAvailableSlot` varchar(3) default null COMMENT 'NotAvailableSlot',"
    s sql=sql_"`AS_OPDRoom_DR` bigint default null COMMENT 'Des Ref OPDRoom',"
    s sql=sql_"`AS_DayClinicOptions` varchar(21) default null COMMENT 'Day Clinic Options',"
    s sql=sql_"primary key (`AS_ChildSub`,`AS_RES_ParRef`)	using BTREE,"
    s sql=sql_"unique key `DataMasterAS` (`AS_RES_ParRef`,`AS_ChildSub`)using BTREE,"
    s sql=sql_"unique key `IndexASDate` (`AS_Date`,`AS_RES_ParRef`,`AS_ChildSub`)using BTREE,"
    s sql=sql_"unique key `IndexDate` (`AS_RES_ParRef`,`AS_Date`,`AS_SessStartTime`,`AS_ChildSub`)	using BTREE)"
    s sql=sql_"engine = InnoDB default CHARSET = utf8mb4 ROW_FORMAT = dynamic;"
    s CreateTableSql=CreateTableSql_sql
    q CreateTableSql
}

/***
  **Description      :插入同步表数据
  **Author           :zhouc
  **Time             :2022/10/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.MySQLDB).InitdhcsynctableSql()
  **Parameter        : his 表名
  **Returns          :
***/
ClassMethod InitdhcsynctableSql()
{
	//导入数据的方法  conf("I",ces中表名) ST_BusinessType^ST_CallMethodName^ST_TableExplain	 同步数据的类为 DHCDoc.Interface.StandAlone.Export
	s conf("I","RBC_SessionType")="BaseData^GetRBCSessionType^挂号职称字典表"
	s conf("I","DHC_RBCSessionTypeService")="BaseData^GetDHCRBCSessionTypeService^挂号职称费用表"
	s conf("I","DHCMarkDoc")="BaseData^GetDHCMarkDoc^科室医生号别对照"
	s conf("I","ARC_ItemExternalCodes")="ARCData^GetARCItemExternalCodes^检验外部代码关联表"
	s conf("I","ARC_ItemExternalInfo")="ARCData^GetARCItemExternalInfo^检验外部数据信息"
	s conf("I","dhc_websysaddins")="BaseData^GetWebsysAddIns^插件配置"
	s conf("I","DHC_CardHardComManager")="BaseData^GetDHCCardHardComManager^读卡设备"
	s conf("I","DHC_CardHardDLLFunction")="BaseData^GetDHCCardHardDLLFunction^读卡方法"
	s conf("I","ARC_OrdFavCat")="ARCData^GetARCOrdFavCat^医嘱模板大类"
	s conf("I","ARC_OrdFavSubCat")="ARCData^GetARCOrdFavSubCat^医嘱模板子类"
	s conf("I","ARC_OrdFavItem")="ARCData^GetARCOrdFavItem^医嘱模板项目"
	s conf("I","DHC_UserFavItems")="ARCData^GetDHCUserFavItems^医嘱套类别"
	s conf("I","ARC_OrdSetsHosp")="ARCData^GetARCOrdSetsHosp^医嘱套院区"
	s conf("I","ARC_OrdSetDateOS")="ARCData^GetARCOrdSetDateOS^医嘱套明细中的医嘱"
	s conf("I","RB_ApptSchedule")="BaseData^GetRBApptSchedule^排班数据"

    
	s baseSql="INSERT IGNORE INTO `dhc_synctable`(`ST_TableName`, `ST_BusinessType`, `ST_UpdateUser`, `ST_UpdateDate`, `ST_UpdateTime`, `ST_UpdateNum`, `ST_CallClassName`, `ST_CallMethodName`, `ST_UpdateStatus`, `ST_ActiveFlag`, `ST_TableExplain`, `ST_TableOrganize`) VALUES "
	s valBaseSql="('{tableName}', '{type}', '', '2022/10/20 11:23:36', '{dataTime}', '0', 'DHCDoc.Interface.StandAlone.Export', '{method}', 'N', 'Y', '{desc}', 'Doc')"
	s valSql=""
	s tableName=""
	f{
		s tableName=$o(conf("I",tableName)) q:tableName=""
		s type=$p(conf("I",tableName),"^",1)
		s method=$p(conf("I",tableName),"^",2)
		s desc=$p(conf("I",tableName),"^",3)
		s item=valBaseSql
		s item=$replace(item,"{tableName}",tableName)
		s item=$replace(item,"{type}",type)
		s item=$replace(item,"{dataTime}",$zdt($h,3))
		s item=$replace(item,"{method}",method)
		s item=$replace(item,"{desc}",desc)
		s valSql=$s(valSql="":item,1:valSql_","_item)
	}
	q:valSql="" ""
	s sql=baseSql_valSql_";"


	q sql
}

/***
  **Description      :医生站建表语句
  **Author           :zhouc
  **Time             :2022/10/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.MySQLDB).CreateTableSql("pa_adm")
  **Parameter        : his 表名  ces中表名[空时与his表名一致] cols需要下载到ces中的列[空时全部下载]
  **Returns          :
***/
ClassMethod CreateTableSql(tableName, cesTableName = "", cols = "")
{
	s sql=""
	//1.获取列信息
	s query="select * from information_schema.COLUMNS where table_name = '"_tableName_"'"
	s result=$SYSTEM.SQL.Execute(query)
	s metadata=result.%GetMetadata()
	q:metadata="" sql
	s:cols'="" cols="&"_cols_"&"
	s colSql=""
	while result.%Next() {
		s colName=result.%Get("COLUMN_NAME")
		continue:(cols'="")&&(cols'[("&"_colName_"&"))
		s dataType=result.%Get("DATA_TYPE")
		s dataLen=result.%Get("CHARACTER_MAXIMUM_LENGTH")
		if (dataType="varchar")&&(+dataLen>255){
			s dataType="longtext"
			s dataLen=""
		}
		
		s:dataLen'="" dataLen="("_dataLen_")"
		//是否可为空
		s nullAble=result.%Get("IS_NULLABLE")
		s nullAble=$s(nullAble="NO":"NOT NULL",1:"")
		//是否自增
		s autoIncre=result.%Get("AUTO_INCREMENT")
		s autoIncre=$s(autoIncre="YES":"AUTO_INCREMENT",1:"")
		s:dataType'["int" autoIncre=""
		//默认值
		s default=result.%Get("COLUMN_DEFAULT")
		s:default["$" default=""
		s default=$s(default'="":"DEFAULT "_default,nullAble="NOT NULL":"",1:"DEFAULT "_"NULL")
		//备注
		s comment=result.%Get("DESCRIPTION")
		s comment=$replace(comment,"'","-")
		s comment=$replace(comment,"""","-")
		s:comment'="" comment="COMMENT '"_comment_"'"
		
		s item="`"_colName_"` "_dataType_dataLen_" "_nullAble_" "_default_" "_autoIncre_" "_comment
		s colSql=$s(colSql="":item,1:colSql_","_item)
	}
	q:colSql="" sql
	//2.获取主键信息
	s query="SELECT t.CONSTRAINT_TYPE,t.CONSTRAINT_NAME ,k.COLUMN_NAME,k.REFERENCED_TABLE_NAME,k.REFERENCED_COLUMN_NAME "
	s query=query_" FROM information_schema.table_constraints t JOIN information_schema.key_column_usage k USING ( constraint_name, table_schema, table_name ) "
	s query=query_" WHERE t.constraint_type = 'PRIMARY KEY' AND t.table_name = '"_tableName_"'"
	s result=$SYSTEM.SQL.Execute(query,1)
	s (priKeyStr,forKeySql)=""
	s keySql=""
	while result.%Next() {
		s keyCol=result.%Get("COLUMN_NAME")
		continue:(cols'="")&&(cols'[("&"_keyCol_"&"))
		s keyType=result.%Get("CONSTRAINT_TYPE")
		s keyName=result.%Get("CONSTRAINT_NAME")
		s keyToTable=result.%Get("REFERENCED_TABLE_NAME")
		s keyToCol=result.%Get("REFERENCED_COLUMN_NAME")
		s item=""
		if (keyType="FOREIGN KEY"){
			continue	//暂时不考虑外键
			s item="CONSTRAINT `"_keyName_"` FOREIGN KEY (`"_keyCol_"`) REFERENCES `"_keyToTable_"` (`"_keyToCol_"`)"
			s forKeySql=$s(forKeySql="":item,1:forKeySql_","_item)
		}elseif(keyType="PRIMARY KEY"){
			//s item="PRIMARY KEY (`"_keyCol_"`) USING BTREE"
			s priKeyStr=$s(priKeyStr="":keyCol,1:priKeyStr_","_keyCol)
		}
	}
	s priKeySql=""
	s:priKeyStr'="" priKeySql="PRIMARY KEY (`"_$replace(priKeyStr,",","`,`")_"`) USING BTREE"
	s:priKeySql'="" keySql=$s(keySql="":priKeySql,1:keySql_","_priKeySql)
	s:forKeySql'="" keySql=$s(keySql="":forKeySql,1:keySql_","_forKeySql)
	
	
	//3.获取索引 只建有索引字段的单索引
	s query="select * from information_schema.INDEXES where table_name ='"_tableName_"' ORDER BY INDEX_NAME , ORDINAL_POSITION ASC "
	s result=$SYSTEM.SQL.Execute(query,1)
	k indexArr
	while result.%Next() {
		s indexCol=result.%Get("COLUMN_NAME")
		continue:(cols'="")&&(cols'[("&"_indexCol_"&"))
		s indexName=result.%Get("INDEX_NAME")
		s oldIndexItem=$g(indexArr(indexName))
		s indexArr(indexName)=$s(oldIndexItem="":indexCol,1:oldIndexItem_"`,`"_indexCol)
	}
	s indexSql=""
	s indexName=""
	f {
		s indexName=$o(indexArr(indexName)) q:indexName=""
		s indexCols=indexArr(indexName)
		continue:indexCols=""
		s item="UNIQUE KEY `"_indexName_"` (`"_indexCols_"`) USING BTREE"
		s indexSql=$s(indexSql="":item,1:indexSql_","_item)
	}
	
	s:cesTableName="" cesTableName=tableName
	s sql=sql_"drop table if exists "_cesTableName_";"
	s sql=sql_"CREATE TABLE `"_cesTableName_"` ("
	s sql=sql_colSql
	s:keySql'="" sql=sql_","_keySql
	s:indexSql'="" sql=sql_","_indexSql
	s sql=sql_") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;"
	q sql
}

}
