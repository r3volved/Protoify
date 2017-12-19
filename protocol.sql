CREATE TABLE IF NOT EXISTS `Character` (
  `unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `unitName` VARCHAR(128) COLLATE utf8_bin NULL,
  `stars` INT(32) COLLATE utf8_bin NULL,
  `level` INT(32) COLLATE utf8_bin NULL,
  `totalXp` INT(32) COLLATE utf8_bin NULL,
  `promotionRecipeReference` VARCHAR(128) COLLATE utf8_bin NULL,
  `gearLevel` INT(32) COLLATE utf8_bin NULL,
  `equippedStatModOld` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`unitId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Skill` (
  `skillId` VARCHAR(128) COLLATE utf8_bin NULL,
  `level` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`skillId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Equipped` (
  `gearId` VARCHAR(128) COLLATE utf8_bin NULL,
  `slot` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`gearId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Mod` (
  `modId` VARCHAR(128) COLLATE utf8_bin NULL,
  `modDefinition` VARCHAR(128) COLLATE utf8_bin NULL,
  `level` INT(32) COLLATE utf8_bin NULL,
  `quality` INT(32) COLLATE utf8_bin NULL,
  `xp` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`modId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PlayerProfile` (
  `name` VARCHAR(128) COLLATE utf8_bin NULL,
  `level` INT(32) COLLATE utf8_bin NULL,
  `pvpWins` INT(32) COLLATE utf8_bin NULL,
  `pvpLosses` INT(64) COLLATE utf8_bin NULL,
  `pvpRank` INT(32) COLLATE utf8_bin NULL,
  `allyCode` INT(64) COLLATE utf8_bin NULL,
  `playerId` VARCHAR(128) COLLATE utf8_bin NULL,
  `guildId` VARCHAR(128) COLLATE utf8_bin NULL,
  `guildName` VARCHAR(128) COLLATE utf8_bin NULL,
  `guildLogo` VARCHAR(128) COLLATE utf8_bin NULL,
  `guildLogoBackground` VARCHAR(128) COLLATE utf8_bin NULL,
  `guildBannerColor` VARCHAR(128) COLLATE utf8_bin NULL,
  `guildBannerLogo` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`playerId`, `guildId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PvP` (
  `combatType` INT(64) COLLATE utf8_bin NULL,
  `arenaRank` INT(64) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `ArenaSquad` (
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitKey` (
  `unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `unitName` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`unitId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PlayerStat` (
  `name` VARCHAR(128) COLLATE utf8_bin NULL,
  `value` INT(64) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Ability` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `prefabName` VARCHAR(128) COLLATE utf8_bin NULL,
  `stackingLineOverride` VARCHAR(128) COLLATE utf8_bin NULL,
  `cooldown` INT(32) COLLATE utf8_bin NULL,
  `icon` VARCHAR(128) COLLATE utf8_bin NULL,
  `applyTypeTooltipKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `buttonLocation` INT(32) COLLATE utf8_bin NULL,
  `shortDescKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `AbilityReference` (
  `abilityId` VARCHAR(128) COLLATE utf8_bin NULL,
  `requiredTier` INT(32) COLLATE utf8_bin NULL,
  `requiredRarity` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`abilityId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `AbilityTier` (
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `upgradeDescKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `cooldownOverride` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `ActionLink` (
  `link` VARCHAR(128) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `BattleCondition` (
  `conditionType` INT(32) COLLATE utf8_bin NULL,
  `conditionValue` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `BattleEnvironment` (
  `prefab` VARCHAR(128) COLLATE utf8_bin NULL,
  `audioPackage` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `BucketItem` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `weight` INT(32) COLLATE utf8_bin NULL,
  `minQuantity` INT(32) COLLATE utf8_bin NULL,
  `maxQuantity` INT(32) COLLATE utf8_bin NULL,
  `rarity` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `CampaignElementIdentifier` (
  `campaignId` VARCHAR(128) COLLATE utf8_bin NULL,
  `campaignMapId` VARCHAR(128) COLLATE utf8_bin NULL,
  `campaignNodeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `campaignNodeDifficulty` INT(32) COLLATE utf8_bin NULL,
  `campaignMissionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`campaignId`, `campaignMapId`, `campaignNodeId`, `campaignMissionId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Category` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `uiFilter` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Challenge` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `actionLink` VARCHAR(128) COLLATE utf8_bin NULL,
  `platformAchievementId` VARCHAR(128) COLLATE utf8_bin NULL,
  `claimType` INT(32) COLLATE utf8_bin NULL,
  `rewardType` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`, `platformAchievementId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `CraftingMaterialDef` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `iconKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `xpValue` INT(32) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `unitClass` INT(32) COLLATE utf8_bin NULL,
  `rarity` INT(32) COLLATE utf8_bin NULL,
  `trainingCost` INT(32) COLLATE utf8_bin NULL,
  `trainingCostMaxLevel` INT(32) COLLATE utf8_bin NULL,
  `unitDefReference` VARCHAR(128) COLLATE utf8_bin NULL,
  `tier` INT(32) COLLATE utf8_bin NULL,
  `obtainableTime` INT(64) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `CrewGroupSlotDef` (
  `maxSize` INT(32) COLLATE utf8_bin NULL,
  `rarityRequirement` INT(32) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `statTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`statTableId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `CrewMember` (
  `unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `slot` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`unitId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `CurrencyItem` (
  `currency` INT(32) COLLATE utf8_bin NULL,
  `quantity` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `DecimalTable` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `DecimalTableRow` (
  `index` INT(32) COLLATE utf8_bin NULL,
  `valueDecimal` INT(64) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Effect` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `param` VARCHAR(128) COLLATE utf8_bin NULL,
  `chance` INT(32) COLLATE utf8_bin NULL,
  `contextIndex` INT(32) COLLATE utf8_bin NULL,
  `applyType` INT(32) COLLATE utf8_bin NULL,
  `damageType` INT(32) COLLATE utf8_bin NULL,
  `persistentIcon` VARCHAR(128) COLLATE utf8_bin NULL,
  `triggeredVfx` VARCHAR(128) COLLATE utf8_bin NULL,
  `triggeredLocKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `maxBonusMoves` INT(32) COLLATE utf8_bin NULL,
  `multiplierAmountDecimal` INT(32) COLLATE utf8_bin NULL,
  `contextMultiplierDecimal` INT(32) COLLATE utf8_bin NULL,
  `additiveAmountDecimal` INT(32) COLLATE utf8_bin NULL,
  `resultVarianceDecimal` INT(32) COLLATE utf8_bin NULL,
  `persistentLocKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `stackingLineOverride` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EffectReference` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `contextIndex` INT(32) COLLATE utf8_bin NULL,
  `maxBonusMove` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EffectTag` (
  `tag` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EffectTagCriteria` (
  `tag` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EffectTarget` (
  `unitSelect` INT(32) COLLATE utf8_bin NULL,
  `battleSide` INT(32) COLLATE utf8_bin NULL,
  `unitClass` INT(32) COLLATE utf8_bin NULL,
  `forceAlignment` INT(32) COLLATE utf8_bin NULL,
  `healthState` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EffectTargetCategoryCriteria` (
  `categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`categoryId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EquipmentDef` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `iconKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `requiredLevel` INT(32) COLLATE utf8_bin NULL,
  `recipeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `tier` INT(32) COLLATE utf8_bin NULL,
  `mark` VARCHAR(128) COLLATE utf8_bin NULL,
  `obtainableTime` INT(64) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`, `recipeId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EventSampling` (
  `eventId` VARCHAR(128) COLLATE utf8_bin NULL,
  `spenderValue` INT(32) COLLATE utf8_bin NULL,
  `nonSpenderValue` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`eventId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GearDefinition` (
  `idKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `inknownId2` INT(32) COLLATE utf8_bin NULL,
  `inknownId3` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GearDefinitions` (
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildBannerColorDef` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `tintColor` VARCHAR(128) COLLATE utf8_bin NULL,
  `backgroundColor` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildBannerDef` (
  `logo` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildBannerLogoDef` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `logo` VARCHAR(128) COLLATE utf8_bin NULL,
  `uiLogo` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildExchangeItem` (
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildRaid` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `priority` INT(32) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `summaryKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `textureImage` VARCHAR(128) COLLATE utf8_bin NULL,
  `squadType` INT(32) COLLATE utf8_bin NULL,
  `iconPrefab` VARCHAR(128) COLLATE utf8_bin NULL,
  `promotionKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `portraitIcon` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildRaidConfig` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `raidType` INT(32) COLLATE utf8_bin NULL,
  `rosterRefreshType` INT(32) COLLATE utf8_bin NULL,
  `raidDuration` INT(64) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildRaidRosterRefresh` (
  `type` VARCHAR(128) COLLATE utf8_bin NULL,
  `value` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `HelpEntry` (
  `id` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `HelpTile` (
  `textKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `image` VARCHAR(128) COLLATE utf8_bin NULL,
  `titleKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `LookupActionLink` (
  `deskKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `LookupMission` (
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `MessageDialog` (
  `titleKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Position` (
  `x` VARCHAR(128) COLLATE utf8_bin NULL,
  `y` VARCHAR(128) COLLATE utf8_bin NULL,
  `z` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PowerUpBundle` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `targetLevel` INT(32) COLLATE utf8_bin NULL,
  `targetGearTier` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Recipe` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `iconKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `unlockLevel` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Requirement` (
  `evalType` INT(32) COLLATE utf8_bin NULL,
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `RequirementItem` (
  `type` INT(32) COLLATE utf8_bin NULL,
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `value` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `SkillDefinition` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `iconKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `abilityReference` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `SkillDefinitionReference` (
  `skillId` VARCHAR(128) COLLATE utf8_bin NULL,
  `requiredTier` INT(32) COLLATE utf8_bin NULL,
  `requiredRarity` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`skillId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `SkillTierDefinition` (
  `recipeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `requiredUnitLevel` INT(32) COLLATE utf8_bin NULL,
  `requiredUnitRarity` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`recipeId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Stat` (
  `statId` VARCHAR(128) COLLATE utf8_bin NULL,
  `unitStatId` INT(32) COLLATE utf8_bin NULL,
  `statValueDecimalOld` INT(32) COLLATE utf8_bin NULL,
  `statValueDecimal` INT(64) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`statId`, `unitStatId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatDef` (
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatMod` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `definitionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `level` INT(32) COLLATE utf8_bin NULL,
  `tier` INT(32) COLLATE utf8_bin NULL,
  `xp` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`, `definitionId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModDefinition` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `slot` INT(32) COLLATE utf8_bin NULL,
  `setId` VARCHAR(128) COLLATE utf8_bin NULL,
  `rarity` INT(32) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `levelTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`, `setId`, `levelTableId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModSetBonus` (
  `abilityId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`abilityId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModSetDefinition` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `name` VARCHAR(128) COLLATE utf8_bin NULL,
  `icon` VARCHAR(128) COLLATE utf8_bin NULL,
  `setCount` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModStat` (
  `updaterId` VARCHAR(128) COLLATE utf8_bin NULL,
  `roll` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`updaterId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModUpdaterDefinition` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `tableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `minIncrementValueDecimal` INT(64) COLLATE utf8_bin NULL,
  `maxIncrementValueDecimal` INT(64) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`, `tableId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatProgression` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `operation` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatValueRange` (
  `stat` INT(32) COLLATE utf8_bin NULL,
  `battleStat` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatValueRangeNumber` (
  `value` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `SystemModifier` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `system` INT(32) COLLATE utf8_bin NULL,
  `labelKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PointsMap` (
  `key` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PointsDetails` (
  `key` VARCHAR(128) COLLATE utf8_bin NULL,
  `value` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Table` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `TableRow` (
  `key` VARCHAR(128) COLLATE utf8_bin NULL,
  `value` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `TargetingSet` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `TargetingWeight` (
  `type` VARCHAR(128) COLLATE utf8_bin NULL,
  `param` VARCHAR(128) COLLATE utf8_bin NULL,
  `valueDecimal` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Territory` (
  `combatType` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `TerritoryData` (
  `name` VARCHAR(128) COLLATE utf8_bin NULL,
  `points` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `TerritoryBattle` (
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `summaryKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `mapKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `phases` INT(32) COLLATE utf8_bin NULL,
  `points` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `TerritoryWars` (
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `summaryKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `mapKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `iconKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `textureKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `TimeLimitedModifier` (
  `startTime` INT(64) COLLATE utf8_bin NULL,
  `endTime` INT(64) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitDef` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `unitPrefab` VARCHAR(128) COLLATE utf8_bin NULL,
  `thumbnailName` VARCHAR(128) COLLATE utf8_bin NULL,
  `nameKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `rarity` INT(32) COLLATE utf8_bin NULL,
  `maxRarity` INT(32) COLLATE utf8_bin NULL,
  `forceAlignment` INT(32) COLLATE utf8_bin NULL,
  `xpTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `actionCountMin` INT(32) COLLATE utf8_bin NULL,
  `actionCountMax` INT(32) COLLATE utf8_bin NULL,
  `combatType` INT(32) COLLATE utf8_bin NULL,
  `descKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `threatLevel` INT(32) COLLATE utf8_bin NULL,
  `baseId` VARCHAR(128) COLLATE utf8_bin NULL,
  `promotionRecipeReference` VARCHAR(128) COLLATE utf8_bin NULL,
  `statProgressionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `trainingXpWorthBaseValueOverride` INT(32) COLLATE utf8_bin NULL,
  `maxLevelOverride` INT(32) COLLATE utf8_bin NULL,
  `trainingCostMultiplierOverride` INT(32) COLLATE utf8_bin NULL,
  `creationRecipeReference` VARCHAR(128) COLLATE utf8_bin NULL,
  `basePower` INT(32) COLLATE utf8_bin NULL,
  `primaryStat` VARCHAR(128) COLLATE utf8_bin NULL,
  `primaryUnitStat` INT(32) COLLATE utf8_bin NULL,
  `obtainableTime` INT(64) COLLATE utf8_bin NULL,
  `commandCost` INT(32) COLLATE utf8_bin NULL,
  `crewContributionTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `unitClass` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`, `xpTableId`, `baseId`, `statProgressionId`, `categoryId`, `crewContributionTableId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitTierDef` (
  `tier` INT(32) COLLATE utf8_bin NULL,
  `equipmentSet` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `WarDef` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `difficulty` INT(32) COLLATE utf8_bin NULL,
  `dailyResetCapKey` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `WarNodeDef` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `type` INT(32) COLLATE utf8_bin NULL,
  `combatType` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `XpTable` (
  `id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `XpTableRow` (
  `index` INT(32) COLLATE utf8_bin NULL,
  `xp` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  `id` INT(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Character_Skill` (
  `Character_unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Skill_skillId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Character_unitId`, `Skill_skillId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Character_StatDef` (
  `Character_unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Character_unitId`, `StatDef_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Character_Equipped` (
  `Character_unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Equipped_gearId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Character_unitId`, `Equipped_gearId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Character_Mod` (
  `Character_unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Mod_modId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Character_unitId`, `Mod_modId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Mod_CurrencyItem` (
  `Mod_modId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CurrencyItem_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Mod_modId`, `CurrencyItem_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Mod_StatModStat` (
  `Mod_modId` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatModStat_updaterId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Mod_modId`, `StatModStat_updaterId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PlayerProfile_Character` (
  `PlayerProfile_playerId` VARCHAR(128) COLLATE utf8_bin NULL,
  `PlayerProfile_guildId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Character_unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`PlayerProfile_playerId`, `PlayerProfile_guildId`, `Character_unitId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PlayerProfile_PlayerStat` (
  `PlayerProfile_playerId` VARCHAR(128) COLLATE utf8_bin NULL,
  `PlayerProfile_guildId` VARCHAR(128) COLLATE utf8_bin NULL,
  `PlayerStat_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`PlayerProfile_playerId`, `PlayerProfile_guildId`, `PlayerStat_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PlayerProfile_PvP` (
  `PlayerProfile_playerId` VARCHAR(128) COLLATE utf8_bin NULL,
  `PlayerProfile_guildId` VARCHAR(128) COLLATE utf8_bin NULL,
  `PvP_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`PlayerProfile_playerId`, `PlayerProfile_guildId`, `PvP_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PvP_ArenaSquad` (
  `PvP_id` INT(32) COLLATE utf8_bin NOT NULL,
  `ArenaSquad_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`PvP_id`, `ArenaSquad_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `ArenaSquad_UnitKey` (
  `ArenaSquad_id` INT(32) COLLATE utf8_bin NOT NULL,
  `UnitKey_unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`ArenaSquad_id`, `UnitKey_unitId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Ability_BattleCondition` (
  `Ability_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `BattleCondition_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Ability_id`, `BattleCondition_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Ability_AbilityTier` (
  `Ability_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `AbilityTier_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Ability_id`, `AbilityTier_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Ability_EffectTag` (
  `Ability_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `EffectTag_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Ability_id`, `EffectTag_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Ability_EffectReference` (
  `Ability_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `EffectReference_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Ability_id`, `EffectReference_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Ability_MessageDialog` (
  `Ability_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `MessageDialog_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Ability_id`, `MessageDialog_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `AbilityTier_EffectReference` (
  `AbilityTier_id` INT(32) COLLATE utf8_bin NOT NULL,
  `EffectReference_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`AbilityTier_id`, `EffectReference_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `BucketItem_StatMod` (
  `BucketItem_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatMod_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatMod_definitionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`BucketItem_id`, `StatMod_id`, `StatMod_definitionId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Challenge_Requirement` (
  `Challenge_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `Challenge_platformAchievementId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Requirement_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Challenge_id`, `Challenge_platformAchievementId`, `Requirement_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Challenge_BucketItem` (
  `Challenge_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `Challenge_platformAchievementId` VARCHAR(128) COLLATE utf8_bin NULL,
  `BucketItem_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Challenge_id`, `Challenge_platformAchievementId`, `BucketItem_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Challenge_ActionLink` (
  `Challenge_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `Challenge_platformAchievementId` VARCHAR(128) COLLATE utf8_bin NULL,
  `ActionLink_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Challenge_id`, `Challenge_platformAchievementId`, `ActionLink_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `CraftingMaterialDef_CurrencyItem` (
  `CraftingMaterialDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `CurrencyItem_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`CraftingMaterialDef_id`, `CurrencyItem_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `CraftingMaterialDef_LookupMission` (
  `CraftingMaterialDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `LookupMission_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`CraftingMaterialDef_id`, `LookupMission_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `CraftingMaterialDef_LookupActionLink` (
  `CraftingMaterialDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `LookupActionLink_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`CraftingMaterialDef_id`, `LookupActionLink_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `CrewMember_SkillDefinitionReference` (
  `CrewMember_unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `SkillDefinitionReference_skillId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`CrewMember_unitId`, `SkillDefinitionReference_skillId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `DecimalTable_DecimalTableRow` (
  `DecimalTable_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `DecimalTableRow_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`DecimalTable_id`, `DecimalTableRow_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Effect_EffectTarget` (
  `Effect_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `EffectTarget_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Effect_id`, `EffectTarget_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Effect_EffectTag` (
  `Effect_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `EffectTag_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Effect_id`, `EffectTag_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Effect_BattleCondition` (
  `Effect_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `BattleCondition_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Effect_id`, `BattleCondition_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Effect_Effect` (
  `Effect_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Effect_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Effect_EffectReference` (
  `Effect_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `EffectReference_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Effect_id`, `EffectReference_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EffectTarget_EffectTargetCategoryCriteria` (
  `EffectTarget_id` INT(32) COLLATE utf8_bin NOT NULL,
  `EffectTargetCategoryCriteria_categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`EffectTarget_id`, `EffectTargetCategoryCriteria_categoryId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EffectTarget_StatValueRange` (
  `EffectTarget_id` INT(32) COLLATE utf8_bin NOT NULL,
  `StatValueRange_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`EffectTarget_id`, `StatValueRange_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EffectTarget_EffectTagCriteria` (
  `EffectTarget_id` INT(32) COLLATE utf8_bin NOT NULL,
  `EffectTagCriteria_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`EffectTarget_id`, `EffectTagCriteria_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EquipmentDef_StatDef` (
  `EquipmentDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `EquipmentDef_recipeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`EquipmentDef_id`, `EquipmentDef_recipeId`, `StatDef_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EquipmentDef_CurrencyItem` (
  `EquipmentDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `EquipmentDef_recipeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CurrencyItem_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`EquipmentDef_id`, `EquipmentDef_recipeId`, `CurrencyItem_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EquipmentDef_LookupMission` (
  `EquipmentDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `EquipmentDef_recipeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `LookupMission_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`EquipmentDef_id`, `EquipmentDef_recipeId`, `LookupMission_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `EquipmentDef_LookupActionLink` (
  `EquipmentDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `EquipmentDef_recipeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `LookupActionLink_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`EquipmentDef_id`, `EquipmentDef_recipeId`, `LookupActionLink_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GearDefinitions_GearDefinition` (
  `GearDefinitions_id` INT(32) COLLATE utf8_bin NOT NULL,
  `GearDefinition_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`GearDefinitions_id`, `GearDefinition_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildBannerDef_GuildBannerColorDef` (
  `GuildBannerDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `GuildBannerColorDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`GuildBannerDef_id`, `GuildBannerColorDef_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildBannerDef_GuildBannerLogoDef` (
  `GuildBannerDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `GuildBannerLogoDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`GuildBannerDef_id`, `GuildBannerLogoDef_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildExchangeItem_BucketItem` (
  `GuildExchangeItem_id` INT(32) COLLATE utf8_bin NOT NULL,
  `BucketItem_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`GuildExchangeItem_id`, `BucketItem_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildRaid_CampaignElementIdentifier` (
  `GuildRaid_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `CampaignElementIdentifier_campaignId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CampaignElementIdentifier_campaignMapId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CampaignElementIdentifier_campaignNodeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CampaignElementIdentifier_campaignMissionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`GuildRaid_id`, `CampaignElementIdentifier_campaignId`, `CampaignElementIdentifier_campaignMapId`, `CampaignElementIdentifier_campaignNodeId`, `CampaignElementIdentifier_campaignMissionId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GuildRaidConfig_GuildRaidRosterRefresh` (
  `GuildRaidConfig_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `GuildRaidRosterRefresh_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`GuildRaidConfig_id`, `GuildRaidRosterRefresh_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `HelpEntry_HelpTile` (
  `HelpEntry_id` INT(32) COLLATE utf8_bin NULL,
  `HelpTile_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`HelpEntry_id`, `HelpTile_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `LookupActionLink_ActionLink` (
  `LookupActionLink_id` INT(32) COLLATE utf8_bin NOT NULL,
  `ActionLink_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`LookupActionLink_id`, `ActionLink_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `LookupMission_CampaignElementIdentifier` (
  `LookupMission_id` INT(32) COLLATE utf8_bin NOT NULL,
  `CampaignElementIdentifier_campaignId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CampaignElementIdentifier_campaignMapId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CampaignElementIdentifier_campaignNodeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CampaignElementIdentifier_campaignMissionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`LookupMission_id`, `CampaignElementIdentifier_campaignId`, `CampaignElementIdentifier_campaignMapId`, `CampaignElementIdentifier_campaignNodeId`, `CampaignElementIdentifier_campaignMissionId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Recipe_BucketItem` (
  `Recipe_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `BucketItem_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Recipe_id`, `BucketItem_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Recipe_Requirement` (
  `Recipe_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `Requirement_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Recipe_id`, `Requirement_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Requirement_RequirementItem` (
  `Requirement_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `RequirementItem_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Requirement_id`, `RequirementItem_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `SkillDefinition_SkillTierDefinition` (
  `SkillDefinition_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `SkillTierDefinition_recipeId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`SkillDefinition_id`, `SkillTierDefinition_recipeId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatDef_Stat` (
  `StatDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `Stat_statId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Stat_unitStatId` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatDef_id`, `Stat_statId`, `Stat_unitStatId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatMod_CurrencyItem` (
  `StatMod_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatMod_definitionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CurrencyItem_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatMod_id`, `StatMod_definitionId`, `CurrencyItem_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatMod_StatModStat` (
  `StatMod_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatMod_definitionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatModStat_updaterId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatMod_id`, `StatMod_definitionId`, `StatModStat_updaterId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModDefinition_LookupMission` (
  `StatModDefinition_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatModDefinition_setId` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatModDefinition_levelTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `LookupMission_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatModDefinition_id`, `StatModDefinition_setId`, `StatModDefinition_levelTableId`, `LookupMission_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModDefinition_LookupActionLink` (
  `StatModDefinition_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatModDefinition_setId` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatModDefinition_levelTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `LookupActionLink_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatModDefinition_id`, `StatModDefinition_setId`, `StatModDefinition_levelTableId`, `LookupActionLink_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModSetBonus_Stat` (
  `StatModSetBonus_abilityId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Stat_statId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Stat_unitStatId` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatModSetBonus_abilityId`, `Stat_statId`, `Stat_unitStatId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModSetDefinition_StatModSetBonus` (
  `StatModSetDefinition_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatModSetBonus_abilityId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatModSetDefinition_id`, `StatModSetBonus_abilityId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatModStat_Stat` (
  `StatModStat_updaterId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Stat_statId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Stat_unitStatId` INT(32) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatModStat_updaterId`, `Stat_statId`, `Stat_unitStatId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatProgression_StatDef` (
  `StatProgression_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatProgression_id`, `StatDef_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StatValueRange_StatValueRangeNumber` (
  `StatValueRange_id` INT(32) COLLATE utf8_bin NOT NULL,
  `StatValueRangeNumber_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`StatValueRange_id`, `StatValueRangeNumber_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `SystemModifier_TimeLimitedModifier` (
  `SystemModifier_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `TimeLimitedModifier_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`SystemModifier_id`, `TimeLimitedModifier_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PointsMap_PointsDetails` (
  `PointsMap_id` INT(32) COLLATE utf8_bin NOT NULL,
  `PointsDetails_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`PointsMap_id`, `PointsDetails_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Table_TableRow` (
  `Table_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `TableRow_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Table_id`, `TableRow_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `TargetingSet_TargetingWeight` (
  `TargetingSet_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `TargetingWeight_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`TargetingSet_id`, `TargetingWeight_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Territory_TerritoryData` (
  `Territory_id` INT(32) COLLATE utf8_bin NOT NULL,
  `TerritoryData_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`Territory_id`, `TerritoryData_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `TerritoryBattle_Territory` (
  `TerritoryBattle_id` INT(32) COLLATE utf8_bin NOT NULL,
  `Territory_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`TerritoryBattle_id`, `Territory_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitDef_CrewGroupSlotDef` (
  `UnitDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_xpTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_baseId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_statProgressionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_crewContributionTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CrewGroupSlotDef_statTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`UnitDef_id`, `UnitDef_xpTableId`, `UnitDef_baseId`, `UnitDef_statProgressionId`, `UnitDef_categoryId`, `UnitDef_crewContributionTableId`, `CrewGroupSlotDef_statTableId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitDef_SkillDefinitionReference` (
  `UnitDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_xpTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_baseId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_statProgressionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_crewContributionTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `SkillDefinitionReference_skillId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`UnitDef_id`, `UnitDef_xpTableId`, `UnitDef_baseId`, `UnitDef_statProgressionId`, `UnitDef_categoryId`, `UnitDef_crewContributionTableId`, `SkillDefinitionReference_skillId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitDef_StatDef` (
  `UnitDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_xpTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_baseId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_statProgressionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_crewContributionTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `StatDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`UnitDef_id`, `UnitDef_xpTableId`, `UnitDef_baseId`, `UnitDef_statProgressionId`, `UnitDef_categoryId`, `UnitDef_crewContributionTableId`, `StatDef_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitDef_UnitTierDef` (
  `UnitDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_xpTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_baseId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_statProgressionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_crewContributionTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitTierDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`UnitDef_id`, `UnitDef_xpTableId`, `UnitDef_baseId`, `UnitDef_statProgressionId`, `UnitDef_categoryId`, `UnitDef_crewContributionTableId`, `UnitTierDef_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitDef_Ability` (
  `UnitDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_xpTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_baseId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_statProgressionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_crewContributionTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `Ability_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`UnitDef_id`, `UnitDef_xpTableId`, `UnitDef_baseId`, `UnitDef_statProgressionId`, `UnitDef_categoryId`, `UnitDef_crewContributionTableId`, `Ability_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitDef_AbilityReference` (
  `UnitDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_xpTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_baseId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_statProgressionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_crewContributionTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `AbilityReference_abilityId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`UnitDef_id`, `UnitDef_xpTableId`, `UnitDef_baseId`, `UnitDef_statProgressionId`, `UnitDef_categoryId`, `UnitDef_crewContributionTableId`, `AbilityReference_abilityId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitDef_CrewMember` (
  `UnitDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_xpTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_baseId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_statProgressionId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_categoryId` VARCHAR(128) COLLATE utf8_bin NULL,
  `UnitDef_crewContributionTableId` VARCHAR(128) COLLATE utf8_bin NULL,
  `CrewMember_unitId` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`UnitDef_id`, `UnitDef_xpTableId`, `UnitDef_baseId`, `UnitDef_statProgressionId`, `UnitDef_categoryId`, `UnitDef_crewContributionTableId`, `CrewMember_unitId`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `UnitTierDef_StatDef` (
  `UnitTierDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `StatDef_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`UnitTierDef_id`, `StatDef_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `WarDef_WarNodeDef` (
  `WarDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `WarNodeDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`WarDef_id`, `WarNodeDef_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `WarNodeDef_Position` (
  `WarNodeDef_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `Position_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`WarNodeDef_id`, `Position_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `XpTable_XpTableRow` (
  `XpTable_id` VARCHAR(128) COLLATE utf8_bin NULL,
  `XpTableRow_id` INT(32) COLLATE utf8_bin NOT NULL,
  `lastUpdated` TIMESTAMP COLLATE utf8_bin NULL,
  PRIMARY KEY(`XpTable_id`, `XpTableRow_id`)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_bin;

