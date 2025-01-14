<?xml version="1.0" encoding="UTF-8"?>

<!--
~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
~ and United Nations Environment Programme (UNEP)
~
~ This program is free software; you can redistribute it and/or modify
~ it under the terms of the GNU General Public License as published by
~ the Free Software Foundation; either version 2 of the License, or (at
~ your option) any later version.
~
~ This program is distributed in the hope that it will be useful, but
~ WITHOUT ANY WARRANTY; without even the implied warranty of
~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
~ General Public License for more details.
~
~ You should have received a copy of the GNU General Public License
~ along with this program; if not, write to the Free Software
~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
~
~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
~ Rome - Italy. email: geonetwork@osgeo.org
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:geonet="http://www.fao.org/geonetwork"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:param name="displayInfo"/>

   <!-- Convert ISO profile elements to their base type -->
   <xsl:template match="*[@gco:isoType]" priority="99">
      <xsl:element name="{@gco:isoType}">
         <xsl:apply-templates select="@*[name() != 'gco:isoType']|*"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="@*|node()[name(.)!='geonet:info']">
      <xsl:variable name="info" select="geonet:info"/>
      <xsl:copy copy-namespaces="no">
         <xsl:apply-templates select="@*|node()[name(.)!='geonet:info']"/>
         <!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
         <xsl:if test="$displayInfo = 'true'">
            <xsl:copy-of select="$info"/>
         </xsl:if>
      </xsl:copy>
   </xsl:template>

   <!-- Avoid insertion of schema location in the CSW response - which is invalid. -->
   <xsl:template match="@xsi:schemaLocation"/>
  
   <!-- L'harvester RNDT non riconosce l'elemento gmx:MimeFile -->

   <!-- Disabilitare questo template nel caso in cui servano per qualche altro scopo le informazioni aggiuntive fornite da gmx:MimeFile.
        In questo caso l'eliminazione dell'elemento non riconosciuto può essere effettuata in un postprocessing XSL:
        - l'XSL presente (iso-full.xsl) effettua la maggior parte del processing, lasciando nell'output anche le informazioni aggiuntive
          non riconosciute dall'harvester del Repertorio Nazionale.
        - viene creato un servizio CSW aggiuntivo, a cui si fanno effettuare le trasformazioni finali (da MimeType a CharacterString)
   -->
   <xsl:template match="gmx:MimeFileType">
      <gco:CharacterString>
         <xsl:value-of select="text()"/>
      </gco:CharacterString>
   </xsl:template>
   
</xsl:stylesheet>
