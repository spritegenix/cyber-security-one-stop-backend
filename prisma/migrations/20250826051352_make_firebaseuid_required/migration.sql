/*
  Warnings:

  - A unique constraint covering the columns `[firebaseUid]` on the table `Business` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `firebaseUid` to the `Business` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Business" ADD COLUMN     "firebaseUid" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "BusinessPrimaryContact" ADD COLUMN     "firebaseUid" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Business_firebaseUid_key" ON "Business"("firebaseUid");
