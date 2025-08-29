/*
  Warnings:

  - A unique constraint covering the columns `[firebaseUid]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateEnum
CREATE TYPE "AdminNoticeType" AS ENUM ('GLOBAL', 'ALL_USER', 'INDIVIDUAL_USER', 'ALL_BUSINESS', 'INDIVIDUAL_BUSINESS');

-- DropIndex
DROP INDEX "Business_averageRating_idx";

-- DropIndex
DROP INDEX "Business_isBusinessVerified_idx";

-- DropIndex
DROP INDEX "Business_isListed_idx";

-- DropIndex
DROP INDEX "Business_name_idx";

-- DropIndex
DROP INDEX "Business_reviewCount_idx";

-- DropIndex
DROP INDEX "BusinessPrimaryContact_businessId_type_isPrimary_key";

-- DropIndex
DROP INDEX "UserContact_userId_idx";

-- DropIndex
DROP INDEX "UserContact_userId_type_isPrimary_key";

-- AlterTable
ALTER TABLE "Admin" ADD COLUMN     "salt" TEXT,
ALTER COLUMN "password" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Business" ALTER COLUMN "isListed" SET DEFAULT true;

-- AlterTable
ALTER TABLE "BusinessDetails" ADD COLUMN     "primaryWebsite" TEXT;

-- AlterTable
ALTER TABLE "BusinessOperatingHours" ALTER COLUMN "openingTime" DROP NOT NULL,
ALTER COLUMN "closingTime" DROP NOT NULL;

-- AlterTable
ALTER TABLE "BusinessSubscription" ADD COLUMN     "order" INTEGER,
ADD COLUMN     "priceDescription" TEXT,
ADD COLUMN     "priority" INTEGER,
ALTER COLUMN "type" DROP NOT NULL,
ALTER COLUMN "type" SET DEFAULT 'FIRM',
ALTER COLUMN "tierLevel" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Category" ADD COLUMN     "categoryGroupNameId" TEXT,
ADD COLUMN     "description" TEXT,
ADD COLUMN     "order" INTEGER;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "firebaseUid" TEXT,
ALTER COLUMN "hideDetails" SET DEFAULT false;

-- CreateTable
CREATE TABLE "AdminBusinessAdBannerImage" (
    "id" TEXT NOT NULL,
    "order" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "AdminBusinessAdBannerImage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminBusinessMobileAdBannerImage" (
    "id" TEXT NOT NULL,
    "order" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "AdminBusinessMobileAdBannerImage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminNotice" (
    "id" TEXT NOT NULL,
    "businessId" TEXT,
    "userId" TEXT,
    "type" "AdminNoticeType",
    "note" TEXT,
    "expiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "AdminNotice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CategoryGroupName" (
    "id" TEXT NOT NULL,
    "slug" TEXT,
    "order" INTEGER,
    "name" TEXT NOT NULL,

    CONSTRAINT "CategoryGroupName_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "AdminNotice_businessId_key" ON "AdminNotice"("businessId");

-- CreateIndex
CREATE UNIQUE INDEX "AdminNotice_userId_key" ON "AdminNotice"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "CategoryGroupName_slug_key" ON "CategoryGroupName"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "CategoryGroupName_name_key" ON "CategoryGroupName"("name");

-- CreateIndex
CREATE INDEX "Business_id_name_slug_isBusinessVerified_isListed_isBlocked_idx" ON "Business"("id", "name", "slug", "isBusinessVerified", "isListed", "isBlocked");

-- CreateIndex
CREATE INDEX "Business_averageRating_reviewCount_idx" ON "Business"("averageRating", "reviewCount");

-- CreateIndex
CREATE INDEX "BusinessAdBannerImage_businessDetailsId_url_idx" ON "BusinessAdBannerImage"("businessDetailsId", "url");

-- CreateIndex
CREATE INDEX "BusinessAddress_businessDetailsId_idx" ON "BusinessAddress"("businessDetailsId");

-- CreateIndex
CREATE INDEX "BusinessAddress_country_state_city_pincode_idx" ON "BusinessAddress"("country", "state", "city", "pincode");

-- CreateIndex
CREATE INDEX "BusinessCoverImage_businessDetailsId_url_idx" ON "BusinessCoverImage"("businessDetailsId", "url");

-- CreateIndex
CREATE INDEX "BusinessDetails_id_idx" ON "BusinessDetails"("id");

-- CreateIndex
CREATE INDEX "BusinessMobileAdBannerImage_businessDetailsId_url_idx" ON "BusinessMobileAdBannerImage"("businessDetailsId", "url");

-- CreateIndex
CREATE INDEX "BusinessOperatingHours_businessDetailsId_dayOfWeek_openingT_idx" ON "BusinessOperatingHours"("businessDetailsId", "dayOfWeek", "openingTime", "closingTime");

-- CreateIndex
CREATE INDEX "BusinessPrimaryContact_businessId_isVerified_idx" ON "BusinessPrimaryContact"("businessId", "isVerified");

-- CreateIndex
CREATE INDEX "BusinessWebsite_businessDetailsId_url_idx" ON "BusinessWebsite"("businessDetailsId", "url");

-- CreateIndex
CREATE INDEX "Category_id_name_slug_idx" ON "Category"("id", "name", "slug");

-- CreateIndex
CREATE INDEX "City_id_name_slug_idx" ON "City"("id", "name", "slug");

-- CreateIndex
CREATE INDEX "Country_id_name_slug_idx" ON "Country"("id", "name", "slug");

-- CreateIndex
CREATE INDEX "Court_id_name_slug_idx" ON "Court"("id", "name", "slug");

-- CreateIndex
CREATE INDEX "Feedback_id_userId_businessId_idx" ON "Feedback"("id", "userId", "businessId");

-- CreateIndex
CREATE INDEX "Language_id_name_slug_idx" ON "Language"("id", "name", "slug");

-- CreateIndex
CREATE INDEX "Pincode_id_code_slug_idx" ON "Pincode"("id", "code", "slug");

-- CreateIndex
CREATE INDEX "Proficiency_id_name_slug_idx" ON "Proficiency"("id", "name", "slug");

-- CreateIndex
CREATE INDEX "Review_id_userId_businessId_idx" ON "Review"("id", "userId", "businessId");

-- CreateIndex
CREATE INDEX "State_id_name_slug_idx" ON "State"("id", "name", "slug");

-- CreateIndex
CREATE INDEX "Tag_id_name_idx" ON "Tag"("id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "User_firebaseUid_key" ON "User"("firebaseUid");

-- CreateIndex
CREATE INDEX "User_id_name_slug_idx" ON "User"("id", "name", "slug");

-- CreateIndex
CREATE INDEX "UserAddress_userId_idx" ON "UserAddress"("userId");

-- CreateIndex
CREATE INDEX "UserAddress_country_state_city_pincode_idx" ON "UserAddress"("country", "state", "city", "pincode");

-- CreateIndex
CREATE INDEX "UserContact_userId_isVerified_idx" ON "UserContact"("userId", "isVerified");

-- AddForeignKey
ALTER TABLE "AdminBusinessAdBannerImage" ADD CONSTRAINT "AdminBusinessAdBannerImage_id_fkey" FOREIGN KEY ("id") REFERENCES "BusinessAdBannerImage"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdminBusinessMobileAdBannerImage" ADD CONSTRAINT "AdminBusinessMobileAdBannerImage_id_fkey" FOREIGN KEY ("id") REFERENCES "BusinessMobileAdBannerImage"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdminNotice" ADD CONSTRAINT "AdminNotice_businessId_fkey" FOREIGN KEY ("businessId") REFERENCES "Business"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdminNotice" ADD CONSTRAINT "AdminNotice_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Category" ADD CONSTRAINT "Category_categoryGroupNameId_fkey" FOREIGN KEY ("categoryGroupNameId") REFERENCES "CategoryGroupName"("id") ON DELETE SET NULL ON UPDATE CASCADE;
