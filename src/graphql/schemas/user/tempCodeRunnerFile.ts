// export const verifyUserContact = async (
//   _: unknown,
//   args: VerifyUserContactInput
// ) => {
//   const validatedData = VerifyUserContactSchema.parse(args);

//   if (!validatedData) return;

//   return await prisma.$transaction(async (tx) => {
//     // Verify contact
//     const { requestId, isOTPVerified, message } = await verifyOtp(
//       validatedData.requestId,
//       validatedData.otp
//     );

//     if (!isOTPVerified) {
//       throw new Error(message);
//     }
//     const value = validatedData.email || validatedData.phone;
//     const type = validatedData.email ? "EMAIL" : "PHONE";

//     const contact = await tx.userContact.findFirst({
//       where: {
//         value,
//         type,
//         deletedAt: null,
//       },
//       include: {
//         user: true,
//       },
//     });

//     if (!contact) {
//       throw new Error("Contact not found");
//     }

//     let slug: string | undefined;
//     if (!contact.user.slug && contact.user.name) {
//       slug = await generateUniqueSlug({
//         initialSlug: contact.user.name,
//         id: contact.user.id,
//       });
//     }

//     // if (!contact.otp || !contact.otpExpiresAt) {
//     //   throw new Error("No verification code found. Please request a new one.");
//     // }

//     // if (contact.otpExpiresAt < new Date()) {
//     //   throw new Error(
//     //     "Verification code has expired. Please request a new one."
//     //   );
//     // }

//     // if (contact.otp !== validatedData.otp) {
//     //   throw new Error("Invalid verification code");
//     // }

//     // Verify the contact
//     const verifiedContact = await tx.userContact.update({
//       where: { value, deletedAt: null, otp: requestId },
//       data: {
//         isVerified: true,
//         verifiedAt: new Date(),
//         otp: null,
//         otpExpiresAt: null,
//         user: {
//           update: {
//             slug,
//           },
//         },
//       },
//       include: {
//         user: {
//           include: {
//             contacts: true,
//             addresses: {
//               where: {
//                 deletedAt: null,
//               },
//               orderBy: {
//                 createdAt: "desc",
//               },
//             },
//           },
//         },
//       },
//     });

//     // Ensure there's a primary contact
//     await ensurePrimaryContact(tx, verifiedContact.userId);
//     const token = generateToken(verifiedContact.userId, "USER");

//     return {
//       ...verifiedContact,
//       token,
//       message: `${value} verified successfully!`,
//       requestId,
//     };
//   });
// };