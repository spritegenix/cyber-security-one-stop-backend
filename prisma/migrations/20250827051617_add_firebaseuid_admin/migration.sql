/*
  Warnings:

  - A unique constraint covering the columns `[firebaseUid]` on the table `Admin` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `firebaseUid` to the `Admin` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Admin" ADD COLUMN     "firebaseUid" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Admin_firebaseUid_key" ON "Admin"("firebaseUid");
