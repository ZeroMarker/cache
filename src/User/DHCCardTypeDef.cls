Class User.DHCCardTypeDef Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CTD_RowID, SqlTableName = DHC_CardTypeDef, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CTD_Code
Property CTDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CTD_Code ];

/// CTD_Desc
Property CTDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CTD_Desc ];

/// CTD_FareType
Property CTDFareType As %Library.String(DISPLAYLIST = ",NOPay,Charge", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",NP,C") [ SqlColumnNumber = 4, SqlFieldName = CTD_FareType ];

/// CTD_PrtINVFlag
Property CTDPrtINVFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CTD_PrtINVFlag ];

/// CTD_UseINVType
Property CTDUseINVType As %Library.String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,Registeration,Login", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O,E,R,L") [ SqlColumnNumber = 6, SqlFieldName = CTD_UseINVType ];

/// CTD_CardFareCost
Property CTDCardFareCost As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CTD_CardFareCost ];

/// CTD_ReclaimFlag
Property CTDReclaimFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CTD_ReclaimFlag ];

/// CTD_DefaultFlag
Property CTDDefaultFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CTD_DefaultFlag ];

/// CTD_DateFrom
Property CTDDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = CTD_DateFrom ];

/// CTD_DateTo
Property CTDDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = CTD_DateTo ];

/// CTD_ActiveFlag
Property CTDActiveFlag As %Library.String(DISPLAYLIST = ",In Effect,Stop Emit,Stop Use", MAXLEN = 9, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",IE,SE,SU") [ SqlColumnNumber = 12, SqlFieldName = CTD_ActiveFlag ];

/// CTD_SearchMasFlag
Property CTDSearchMasFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = CTD_SearchMasFlag ];

/// CTD_SetFocusElement
Property CTDSetFocusElement As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CTD_SetFocusElement ];

/// CTD_HardCom_DR
Property CTDHardComDR As User.DHCCardHardComManager [ SqlColumnNumber = 15, SqlFieldName = CTD_HardCom_DR ];

/// CTD_BarCodeCom_DR
Property CTDBarCodeComDR As User.DHCCardHardComManager [ SqlColumnNumber = 16, SqlFieldName = CTD_BarCodeCom_DR ];

/// CTD_ReadCardMode
Property CTDReadCardMode As %Library.String(DISPLAYLIST = ",Handle Input CardNo,Read Card", MAXLEN = 19, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Handle,Read") [ SqlColumnNumber = 17, SqlFieldName = CTD_ReadCardMode ];

/// CTD_Current Card No Length
Property CTDCardNoLength As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = CTD_CardNoLength ];

/// CTD_Set Security No Flag
Property CTDSecurityNoFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = CTD_SecurityNoFlag ];

/// CTD_PreCardFlag
Property CTDPreCardFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = CTD_PreCardFlag ];

/// CTD_ReadCardFocusElement
Property CTDReadCardFocusElement As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CTD_ReadCardFocusElement ];

/// CTD_PANoCardRefFlag
Property CTDPANoCardRefFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = CTD_PANoCardRefFlag ];

/// CTD_CardRefFocusElement
Property CTDCardRefFocusElement As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CTD_CardRefFocusElement ];

/// CTD_Note3
Property CTDOverWriteFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = CTD_OverWriteFlag ];

/// CTD_CardAccountRelation
Property CTDCardAccountRelation As %Library.String(DISPLAYLIST = ",None,Create Account,Create Link", MAXLEN = 14, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,CA,CL") [ SqlColumnNumber = 25, SqlFieldName = CTD_CardAccountRelation ];

/// CTD_INVPRTXMLName
Property CTDINVPRTXMLName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = CTD_INVPRTXMLName ];

/// CTD_PatPageXMLName
Property CTDPatPageXMLName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = CTD_PatPageXMLName ];

/// CTD_StChangeValidateFlag
Property CTDStChangeValidateFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = CTD_StChangeValidateFlag ];

/// CTD_SearchCardNoMode
Property CTDSearchCardNoMode As %Library.String(DISPLAYLIST = ",Priority CardNo,Type and CardNo", MAXLEN = 15, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",PC,TC") [ SqlColumnNumber = 29, SqlFieldName = CTD_SearchCardNoMode ];

/// CTD_CardNamePlateStr
Property CTDCardNamePlateStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = CTD_CardNamePlateStr ];

/// CTD_Validate CardType Mode
Property CTDValidateMode As %Library.String(DISPLAYLIST = ",None,ID Unique,Colligate Unique", MAXLEN = 9, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,IDU,CQU") [ SqlColumnNumber = 31, SqlFieldName = CTD_ValidateMode ];

/// CTD_SupportLossFlag
Property CTDSupportLossFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = CTD_SupportLossFlag ];

/// CTD_SupportExChangeFlag
Property CTDSupportExChangeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = CTD_SupportExChangeFlag ];

/// CTD_ Fill Flag
Property CTDSupportFillFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = CTD_SupportFillFlag ];

/// CTD_OverLayPatInfoFlag
Property CTDOverLayPatInfoFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = CTD_OverLayPatInfoFlag ];

/// CTD_RegType
Property CTDRegType As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",None,APP,REG,ALL", MAXLEN = 30, TRUNCATE = 0, VALUELIST = ",N,APP,REG,ALL") [ SqlColumnNumber = 36, SqlFieldName = CTD_RegType ];

/// 使用登记号作为卡号
Property CTDUsePANoToCardNO As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = CTD_UsePANoToCardNO ];

/// 卡支付是否需要验证
Property CTDCardPayNeedCheckFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = CTD_CardPayNeedCheckFlag ];

/// 临时卡权限
Property CTDTemporaryCardFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = CTD_TemporaryCardFlag ];

/// 本院职工是否收取卡费
Property CTDNotPayCardFeePatType As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = CTD_NotPayCardFeePatType ];

/// 是否必须UID
Property CTDNeedUIDFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = CTD_NeedUIDFlag ];

/// 外部卡关联
Property CTDExtCardLinkStr As %Library.String [ SqlColumnNumber = 42, SqlFieldName = CTD_ExtCardLinkStr ];

/// 外部卡号可为空标志
Property CTDAllowNoCardNoFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = CTD_AllowNoCardNoFlag ];

/// 可选证件类型
Property CTDCredTypeListStr As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = CTD_CredTypeListStr ];

/// 默认证件类型
Property CTDCredTypeDefault As %Library.String [ SqlColumnNumber = 45, SqlFieldName = CTD_CredTypeDefault ];

/// 账户创建模式 2023-04-07 ZhYW (Person:按患者主索引建账户, Card:按卡建账户)
Property CTDAccMCreatMode As %Library.String(DISPLAYLIST = ",Person,Card", TRUNCATE = 1, VALUELIST = ",P,C") [ SqlColumnNumber = 46, SqlFieldName = CTD_AccMCreatMode ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCARDTYPEDef(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CTD_AccMCreatMode">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="CTD_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTD_AllowNoCardNoFlag">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="CTD_BarCodeCom_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTD_CardAccountRelation">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CTD_CardFareCost">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTD_CardNamePlateStr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="CTD_CardNoLength">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CTD_CardPayNeedCheckFlag">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="CTD_CardRefFocusElement">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CTD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTD_CredTypeDefault">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="CTD_CredTypeListStr">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="CTD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTD_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTD_ExtCardLinkStr">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="CTD_FareType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTD_HardCom_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTD_INVPRTXMLName">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CTD_NeedUIDFlag">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="CTD_NotPayCardFeePatType">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="CTD_OverLayPatInfoFlag">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="CTD_OverWriteFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CTD_PANoCardRefFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CTD_PatPageXMLName">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CTD_PreCardFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CTD_PrtINVFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTD_ReadCardFocusElement">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CTD_ReadCardMode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTD_ReclaimFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTD_RegType">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="CTD_SearchCardNoMode">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CTD_SearchMasFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTD_SecurityNoFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CTD_SetFocusElement">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTD_StChangeValidateFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CTD_SupportExChangeFlag">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CTD_SupportFillFlag">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="CTD_SupportLossFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CTD_TemporaryCardFlag">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="CTD_UseINVType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTD_UsePANoToCardNO">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="CTD_ValidateMode">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^DHCCARDTYPEDef</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CTD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CTD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCardTypeDefS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
